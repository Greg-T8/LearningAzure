# -------------------------------------------------------------------------
# Program: 03_multi_turn_agent.py
# Description: Full end-to-end demonstration combining threaded conversation
#              with file search knowledge retrieval
# Context: AI-102 Lab - Agent Service Essentials (Threads + Files + Vector Store)
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

"""
Script 3 — Multi-Turn Conversation with Knowledge Retrieval

Combines threads (conversation state) with file search (knowledge retrieval):
1. Upload a product FAQ document and create a vector store
2. Create an agent with file search capability
3. Run a multi-turn conversation where each question builds on the previous
4. Observe how the thread maintains context AND file search provides facts

This demonstrates the interplay between:
- Thread storage (Cosmos DB in standard setup): Remembers conversation history
- File storage (Azure Storage in standard setup): Holds the uploaded document
- Vector store (AI Search in standard setup): Enables semantic search over the document

Usage:
    cd AI-102/hands-on-labs/agentic/lab-agent-essentials/terraform
    $env:PROJECT_ENDPOINT = terraform output -raw project_endpoint
    $env:MODEL_DEPLOYMENT_NAME = terraform output -raw model_deployment_name
    cd ../scripts
    python 03_multi_turn_agent.py
"""

import os
import sys
from pathlib import Path

from azure.ai.projects import AIProjectClient
from azure.ai.agents.models import (
    FileSearchTool,
    FilePurpose,
    ListSortOrder,
)
from azure.identity import DefaultAzureCredential


def main() -> None:
    """Orchestrate the multi-turn knowledge retrieval demonstration."""

    # Initialize the Foundry project client
    client = create_project_client()

    # Create a product FAQ document
    faq_path = create_product_faq()

    # Upload and vectorize the document
    file = upload_file(client, faq_path)
    vector_store = create_vector_store(client, file.id)

    # Create agent with file search
    agent = create_knowledge_agent(client, vector_store.id)

    # Run a multi-turn conversation
    thread = client.agents.threads.create()
    print(f"\n--- Thread Created ---")
    print(f"  ID: {thread.id}")
    print(f"  (Thread state stored in Cosmos DB in standard setup)")

    run_multi_turn_conversation(client, agent.id, thread.id)

    # Show the complete conversation history
    show_conversation_history(client, thread.id)

    # Clean up resources
    cleanup(client, agent.id, thread.id, vector_store.id, file.id, faq_path)


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


def create_product_faq() -> Path:
    """
    Generate a product catalog FAQ document for the agent to search.

    This simulates a product knowledge base that the agent will reference
    during multi-turn conversations. Each question in the conversation
    targets different parts of this document.

    Returns:
        Path: File path to the generated FAQ document
    """

    content = """# Contoso Cloud Services — Product FAQ

## Azure Migration Accelerator (AMA)

### Overview
AMA is an automated migration toolkit for moving on-premises workloads to Azure.
Supports VM migrations, database migrations, and application modernization.

### Pricing
- Starter tier: $2,500/month — up to 50 VMs
- Professional tier: $7,500/month — up to 200 VMs, includes database migration
- Enterprise tier: $15,000/month — unlimited VMs, includes app modernization

### Requirements
- Source environment: VMware vSphere 6.7+, Hyper-V 2016+, or physical servers
- Network: Minimum 100 Mbps bandwidth between source and Azure
- Azure subscription with Contributor access

### SLA
- Migration success rate: 99.5%
- Support response time: 4 hours (Professional), 1 hour (Enterprise)
- Rollback capability: Full rollback within 72 hours of migration


## Contoso Security Shield (CSS)

### Overview
CSS provides unified threat detection and response across hybrid cloud environments.
Integrates with Microsoft Defender for Cloud, Sentinel, and third-party SIEM tools.

### Pricing
- Basic: $5/endpoint/month — threat detection only
- Standard: $12/endpoint/month — detection + automated response
- Premium: $25/endpoint/month — detection + response + threat hunting

### Features
- Real-time threat detection with ML-powered anomaly detection
- Automated incident response playbooks
- Compliance reporting for SOC 2, ISO 27001, HIPAA
- Integration with Microsoft Sentinel for SIEM correlation

### SLA
- Threat detection latency: < 5 minutes
- Automated response time: < 2 minutes
- Uptime guarantee: 99.95%


## Contoso Data Analytics Platform (CDAP)

### Overview
CDAP is a managed analytics platform built on Azure Synapse and Fabric.
Provides end-to-end data pipeline, transformation, and visualization.

### Pricing
- Developer: $1,000/month — 10 users, 1 TB storage
- Business: $5,000/month — 100 users, 10 TB storage, ML integration
- Enterprise: $20,000/month — unlimited users and storage, real-time streaming

### Features
- No-code data pipeline builder
- Pre-built connectors for 200+ data sources
- Built-in ML model training and deployment
- Power BI embedded dashboards
- Real-time streaming analytics (Enterprise tier only)

### Requirements
- Azure subscription with Data Factory and Synapse access
- Minimum 4 vCPU compute for pipeline execution
- Azure Data Lake Storage Gen2 for raw data staging
"""

    # Write to the scripts directory
    file_path = Path(__file__).parent / "contoso_product_faq.md"
    file_path.write_text(content, encoding="utf-8")

    print(f"\n--- Product FAQ Created ---")
    print(f"  File: {file_path.name}")
    print(f"  Size: {len(content)} bytes")
    return file_path


def upload_file(client: AIProjectClient, file_path: Path) -> object:
    """
    Upload the FAQ document to the agent service.

    Args:
        client: Authenticated project client
        file_path: Path to the local file to upload

    Returns:
        The uploaded file object
    """

    file = client.agents.files.upload_and_poll(
        file_path=str(file_path),
        purpose=FilePurpose.AGENTS,
    )

    print(f"\n--- File Uploaded ---")
    print(f"  ID:   {file.id}")
    print(f"  Name: {file.filename}")
    return file


def create_vector_store(client: AIProjectClient, file_id: str) -> object:
    """
    Create a vector store from the uploaded FAQ document.

    Args:
        client: Authenticated project client
        file_id: ID of the uploaded file

    Returns:
        The created vector store object
    """

    vector_store = client.agents.vector_stores.create_and_poll(
        file_ids=[file_id],
        name="contoso-product-faq-store",
    )

    print(f"\n--- Vector Store Created ---")
    print(f"  ID:     {vector_store.id}")
    print(f"  Name:   {vector_store.name}")
    print(f"  Status: {vector_store.status}")
    return vector_store


def create_knowledge_agent(
    client: AIProjectClient,
    vector_store_id: str,
) -> object:
    """
    Create an agent with file search capability for product FAQ queries.

    Args:
        client: Authenticated project client
        vector_store_id: ID of the vector store to attach

    Returns:
        The created agent object
    """

    file_search = FileSearchTool(vector_store_ids=[vector_store_id])

    agent = client.agents.create_agent(
        model=os.environ.get("MODEL_DEPLOYMENT_NAME", "gpt-4o-mini"),
        name="contoso-product-advisor",
        instructions=(
            "You are a Contoso Cloud Services product advisor. "
            "Answer customer questions about products using the FAQ document. "
            "Always cite specific pricing, features, and requirements. "
            "When comparing products, present information in a clear format. "
            "If the customer asks a follow-up, use the conversation context."
        ),
        tools=file_search.definitions,
        tool_resources=file_search.resources,
    )

    print(f"\n--- Knowledge Agent Created ---")
    print(f"  ID:   {agent.id}")
    print(f"  Name: {agent.name}")
    return agent


def run_multi_turn_conversation(
    client: AIProjectClient,
    agent_id: str,
    thread_id: str,
) -> None:
    """
    Execute a multi-turn conversation demonstrating thread context + file search.

    Each question builds on the previous one. The agent must use both:
    - Thread history to understand conversational context (e.g., 'that product')
    - File search to retrieve factual product information

    Args:
        client: Authenticated project client
        agent_id: ID of the knowledge agent
        thread_id: ID of the conversation thread
    """

    # Multi-turn questions — each builds on the previous
    conversation = [
        {
            "message": "What products does Contoso offer for security?",
            "explains": "Requires FILE SEARCH to find CSS product info",
        },
        {
            "message": "What does the Standard tier include and how much is it?",
            "explains": "Requires THREAD CONTEXT ('that product' = CSS) + FILE SEARCH (pricing)",
        },
        {
            "message": "How does that compare to the Premium tier?",
            "explains": "Requires THREAD CONTEXT (Standard tier of CSS) + FILE SEARCH (Premium details)",
        },
        {
            "message": "We also need a data analytics solution. What do you have?",
            "explains": "Requires FILE SEARCH for CDAP, but thread shows customer already evaluating CSS",
        },
        {
            "message": "If we go with Enterprise on both, what is the total monthly cost?",
            "explains": "Requires THREAD CONTEXT (CSS + CDAP) + FILE SEARCH (Enterprise pricing for both)",
        },
    ]

    print(f"\n{'='*70}")
    print(f"  MULTI-TURN CONVERSATION")
    print(f"  Thread ID: {thread_id}")
    print(f"{'='*70}")

    for i, turn in enumerate(conversation, 1):
        print(f"\n--- Turn {i} ---")
        print(f"  Context: {turn['explains']}")
        print(f"  User:    {turn['message']}")

        # Send the user message
        client.agents.messages.create(
            thread_id=thread_id,
            role="user",
            content=turn["message"],
        )

        # Run the agent
        run = client.agents.runs.create_and_process(
            thread_id=thread_id,
            agent_id=agent_id,
        )

        if run.status == "failed":
            print(f"  ERROR: {run.last_error}")
            continue

        # Get the assistant's response
        messages = client.agents.messages.list(
            thread_id=thread_id,
            order=ListSortOrder.DESCENDING,
        )

        for msg in messages:
            if msg.role == "assistant" and msg.run_id == run.id:
                for content in msg.content:
                    if hasattr(content, "text"):

                        # Truncate long responses for readability
                        text = content.text.value
                        if len(text) > 300:
                            text = text[:300] + "..."
                        print(f"  Agent:   {text}")
                break


def show_conversation_history(
    client: AIProjectClient,
    thread_id: str,
) -> None:
    """
    Retrieve and display the full conversation history from the thread.

    This demonstrates that the thread stores the complete conversation state.
    In standard setup, this data is persisted in Azure Cosmos DB.

    Args:
        client: Authenticated project client
        thread_id: ID of the thread to retrieve
    """

    print(f"\n{'='*70}")
    print(f"  FULL CONVERSATION HISTORY")
    print(f"  (Retrieved from thread storage — Cosmos DB in standard setup)")
    print(f"{'='*70}")

    messages = client.agents.messages.list(
        thread_id=thread_id,
        order=ListSortOrder.ASCENDING,
    )

    # Display message count and role summary
    msg_list = list(messages)
    user_count = sum(1 for m in msg_list if m.role == "user")
    assistant_count = sum(1 for m in msg_list if m.role == "assistant")

    print(f"\n  Total messages: {len(msg_list)}")
    print(f"  User messages:  {user_count}")
    print(f"  Agent messages: {assistant_count}")

    for msg in msg_list:
        role_label = "User " if msg.role == "user" else "Agent"

        for content in msg.content:
            if hasattr(content, "text"):

                # Truncate for display
                text = content.text.value
                if len(text) > 120:
                    text = text[:120] + "..."
                print(f"\n  [{role_label}] {text}")


def cleanup(
    client: AIProjectClient,
    agent_id: str,
    thread_id: str,
    vector_store_id: str,
    file_id: str,
    faq_path: Path,
) -> None:
    """
    Delete all resources created during the demonstration.

    Args:
        client: Authenticated project client
        agent_id: ID of the agent to delete
        thread_id: ID of the thread to delete
        vector_store_id: ID of the vector store to delete
        file_id: ID of the uploaded file to delete
        faq_path: Path to the local FAQ file
    """

    print(f"\n--- Cleanup ---")

    client.agents.threads.delete(thread_id=thread_id)
    print(f"  Deleted thread:       {thread_id}")

    client.agents.delete_agent(agent_id=agent_id)
    print(f"  Deleted agent:        {agent_id}")

    client.agents.vector_stores.delete(vector_store_id=vector_store_id)
    print(f"  Deleted vector store: {vector_store_id}")

    client.agents.files.delete(file_id=file_id)
    print(f"  Deleted file:         {file_id}")

    # Remove local FAQ file
    if faq_path.exists():
        faq_path.unlink()
        print(f"  Deleted local file:   {faq_path.name}")

    print(f"\n  All resources cleaned up successfully.")


# -------------------------------------------------------------------------
# Script Entry Point
# -------------------------------------------------------------------------

if __name__ == "__main__":
    main()
