# -------------------------------------------------------------------------
# Program: 02_file_search_agent.py
# Description: Upload files, create a vector store, and use file search
#              to answer questions from uploaded knowledge
# Context: AI-102 Lab - Agent Service Essentials (File Storage + Vector Store)
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

"""
Script 2 — File Storage and Vector Store

Demonstrates the file upload → vector store → file search pipeline:
1. Upload a document to the agent service (stored in Azure Storage in standard setup)
2. Create a vector store from the file (embeddings in AI Search in standard setup)
3. Create an agent with FileSearchTool that can query the uploaded knowledge
4. Ask questions and observe how the agent retrieves information with citations

Usage:
    cd AI-102/hands-on-labs/agentic/lab-agent-essentials/terraform
    $env:PROJECT_ENDPOINT = terraform output -raw project_endpoint
    $env:MODEL_DEPLOYMENT_NAME = terraform output -raw model_deployment_name
    cd ../scripts
    python 02_file_search_agent.py
"""

import os
import sys
import tempfile
from pathlib import Path

from azure.ai.projects import AIProjectClient
from azure.ai.agents.models import (
    FileSearchTool,
    FilePurpose,
    ListSortOrder,
)
from azure.identity import DefaultAzureCredential


def main() -> None:
    """Orchestrate the file search demonstration."""

    # Initialize the Foundry project client
    client = create_project_client()

    # Create a sample knowledge base file
    kb_path = create_knowledge_base_file()

    # Upload the file and create a vector store
    file = upload_file(client, kb_path)
    vector_store = create_vector_store(client, file.id)

    # Create an agent with file search capability
    agent = create_file_search_agent(client, vector_store.id)

    # Run queries against the knowledge base
    thread = client.agents.threads.create()
    run_knowledge_query(client, agent.id, thread.id)

    # Show file and vector store details
    show_file_detail(client, file.id)

    # Clean up all resources
    cleanup(client, agent.id, thread.id, vector_store.id, file.id, kb_path)


# Helper Functions
# -------------------------------------------------------------------------

def create_project_client() -> AIProjectClient:
    """
    Create an authenticated AIProjectClient from environment variables.

    Returns:
        AIProjectClient: Authenticated client for the Foundry project
    """

    endpoint = os.environ.get("PROJECT_ENDPOINT")

    if not endpoint:
        print("ERROR: Set PROJECT_ENDPOINT environment variable.")
        print("  $env:PROJECT_ENDPOINT = terraform output -raw project_endpoint")
        sys.exit(1)

    client = AIProjectClient(
        endpoint=endpoint,
        credential=DefaultAzureCredential(),
    )

    print(f"Connected to project: {endpoint}")
    return client


def create_knowledge_base_file() -> Path:
    """
    Generate a sample knowledge base document for the agent to search.

    This simulates a company policy document that the agent will ingest.
    In production, this would be your actual documents (PDFs, markdown, etc.).

    Returns:
        Path: File path to the generated knowledge base document
    """

    # Create a synthetic company policy document
    content = """# Contoso Travel Agency — Employee Handbook

## Expense Policy

### Per Diem Rates
- Domestic travel: $75/day for meals, $150/day for lodging
- International travel: $100/day for meals, $250/day for lodging
- Receipts required for any single expense over $25

### Booking Requirements
- All flights must be booked at least 14 days in advance
- Economy class required for flights under 6 hours
- Business class allowed for flights over 6 hours with manager approval
- Preferred airline: Contoso Air (employee discount code: CTSOEMP2026)

### Rental Cars
- Compact or mid-size only, unless transporting 3+ employees
- Insurance: Accept the rental company's collision damage waiver
- Fuel: Return with a full tank; fuel charges from the rental company are not reimbursed

## Remote Work Policy

### Eligibility
- Employees with 6+ months tenure are eligible for hybrid remote work
- Fully remote positions require VP-level approval
- All remote workers must be available during core hours: 10 AM - 3 PM local time

### Equipment
- Company provides laptop, monitor, keyboard, and mouse
- $500 annual stipend for home office supplies
- Internet reimbursement: Up to $75/month with proof of bill

## Leave Policy

### Paid Time Off (PTO)
- 0-2 years tenure: 15 days/year
- 3-5 years tenure: 20 days/year
- 6+ years tenure: 25 days/year
- PTO rolls over up to 5 days per year; excess is forfeited

### Sick Leave
- 10 days/year, non-cumulative
- Doctor's note required for absences of 3+ consecutive days

### Parental Leave
- Primary caregiver: 16 weeks paid leave
- Secondary caregiver: 8 weeks paid leave
- Must be taken within 12 months of birth or adoption
"""

    # Write to the scripts directory
    file_path = Path(__file__).parent / "contoso_handbook.md"
    file_path.write_text(content, encoding="utf-8")

    print(f"\n--- Knowledge Base Created ---")
    print(f"  File: {file_path.name}")
    print(f"  Size: {len(content)} bytes")
    return file_path


def upload_file(client: AIProjectClient, file_path: Path) -> object:
    """
    Upload a file to the agent service.

    The file is stored in Azure Storage (BYO storage in standard setup,
    Microsoft-managed in basic setup). The upload operation stores the raw
    file content for later processing.

    Args:
        client: Authenticated project client
        file_path: Path to the local file to upload

    Returns:
        The uploaded file object with its assigned ID
    """

    file = client.agents.files.upload_and_poll(
        file_path=str(file_path),
        purpose=FilePurpose.AGENTS,
    )

    print(f"\n--- File Uploaded ---")
    print(f"  ID:       {file.id}")
    print(f"  Filename: {file.filename}")
    print(f"  Bytes:    {file.bytes}")
    print(f"  Purpose:  {file.purpose}")
    print(f"  (In standard setup, stored in BYO Azure Storage account)")
    return file


def create_vector_store(client: AIProjectClient, file_id: str) -> object:
    """
    Create a vector store from an uploaded file.

    The vector store operation:
    1. Parses the file into chunks
    2. Generates embeddings for each chunk
    3. Stores embeddings in a searchable index

    In standard setup, embeddings are stored in BYO Azure AI Search.
    In basic setup, Microsoft manages the vector storage internally.

    Args:
        client: Authenticated project client
        file_id: ID of the uploaded file to vectorize

    Returns:
        The created vector store object
    """

    vector_store = client.agents.vector_stores.create_and_poll(
        file_ids=[file_id],
        name="contoso-handbook-store",
    )

    print(f"\n--- Vector Store Created ---")
    print(f"  ID:     {vector_store.id}")
    print(f"  Name:   {vector_store.name}")
    print(f"  Status: {vector_store.status}")
    print(f"  Files:  {vector_store.file_counts}")
    print(f"  (In standard setup, indexed in BYO Azure AI Search)")
    return vector_store


def create_file_search_agent(
    client: AIProjectClient,
    vector_store_id: str,
) -> object:
    """
    Create an agent equipped with the FileSearchTool.

    The FileSearchTool enables the agent to search the vector store
    for relevant information when answering questions. This is the bridge
    between the user's question and the uploaded knowledge base.

    Args:
        client: Authenticated project client
        vector_store_id: ID of the vector store to attach

    Returns:
        The created agent object
    """

    # Create the file search tool with the vector store
    file_search = FileSearchTool(vector_store_ids=[vector_store_id])

    agent = client.agents.create_agent(
        model=os.environ.get("MODEL_DEPLOYMENT_NAME", "gpt-4o-mini"),
        name="contoso-hr-assistant",
        instructions=(
            "You are an HR assistant for Contoso Travel Agency. "
            "Answer employee questions about company policies using "
            "the uploaded handbook. Always cite specific policy details "
            "(dollar amounts, day counts, etc.) from the document. "
            "If the handbook does not cover a topic, say so clearly."
        ),
        tools=file_search.definitions,
        tool_resources=file_search.resources,
    )

    print(f"\n--- File Search Agent Created ---")
    print(f"  ID:   {agent.id}")
    print(f"  Name: {agent.name}")
    print(f"  Tools: {[t['type'] for t in agent.tools]}")
    return agent


def run_knowledge_query(
    client: AIProjectClient,
    agent_id: str,
    thread_id: str,
) -> None:
    """
    Query the agent with questions that require knowledge from the uploaded file.

    Each question targets a different section of the handbook, demonstrating
    how file search retrieves specific information from the vector store.

    Args:
        client: Authenticated project client
        agent_id: ID of the file search agent
        thread_id: ID of the thread to use
    """

    # Questions that target different handbook sections
    queries = [
        "What is the international per diem rate for meals?",
        "How many PTO days does a 4-year employee get?",
        "What are the rules for booking business class flights?",
        "How much is the home office stipend?",
    ]

    print(f"\n--- Knowledge Base Queries ---")

    for query in queries:
        print(f"\n  Q: {query}")

        # Send the question
        client.agents.messages.create(
            thread_id=thread_id,
            role="user",
            content=query,
        )

        # Run the agent
        run = client.agents.runs.create_and_process(
            thread_id=thread_id,
            agent_id=agent_id,
        )

        if run.status == "failed":
            print(f"  Run failed: {run.last_error}")
            continue

        # Get the response
        messages = client.agents.messages.list(
            thread_id=thread_id,
            order=ListSortOrder.DESCENDING,
        )

        for msg in messages:
            if msg.role == "assistant" and msg.run_id == run.id:
                for content in msg.content:
                    if hasattr(content, "text"):
                        print(f"  A: {content.text.value[:200]}")

                        # Show annotations (file search citations)
                        if content.text.annotations:
                            for ann in content.text.annotations:
                                print(f"     Citation: {ann.text}")
                break


def show_file_detail(client: AIProjectClient, file_id: str) -> None:
    """
    Display details about the uploaded file to show it persists in the service.

    Args:
        client: Authenticated project client
        file_id: ID of the file to inspect
    """

    print(f"\n--- File Storage Details ---")

    file = client.agents.files.get(file_id=file_id)
    print(f"  ID:        {file.id}")
    print(f"  Filename:  {file.filename}")
    print(f"  Bytes:     {file.bytes}")
    print(f"  Created:   {file.created_at}")
    print(f"  Purpose:   {file.purpose}")


def cleanup(
    client: AIProjectClient,
    agent_id: str,
    thread_id: str,
    vector_store_id: str,
    file_id: str,
    kb_path: Path,
) -> None:
    """
    Delete all resources created during the demonstration.

    Cleanup order matters: agent first, then vector store, then file.

    Args:
        client: Authenticated project client
        agent_id: ID of the agent to delete
        thread_id: ID of the thread to delete
        vector_store_id: ID of the vector store to delete
        file_id: ID of the uploaded file to delete
        kb_path: Path to the local knowledge base file
    """

    print(f"\n--- Cleanup ---")

    client.agents.threads.delete(thread_id=thread_id)
    print(f"  Deleted thread: {thread_id}")

    client.agents.delete_agent(agent_id=agent_id)
    print(f"  Deleted agent:  {agent_id}")

    client.agents.vector_stores.delete(vector_store_id=vector_store_id)
    print(f"  Deleted vector store: {vector_store_id}")

    client.agents.files.delete(file_id=file_id)
    print(f"  Deleted file: {file_id}")

    # Remove local knowledge base file
    if kb_path.exists():
        kb_path.unlink()
        print(f"  Deleted local file: {kb_path.name}")


# -------------------------------------------------------------------------
# Script Entry Point
# -------------------------------------------------------------------------

if __name__ == "__main__":
    main()
