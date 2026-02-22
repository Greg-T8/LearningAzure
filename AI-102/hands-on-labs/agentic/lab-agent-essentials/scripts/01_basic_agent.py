# -------------------------------------------------------------------------
# Program: 01_basic_agent.py
# Description: Create an agent and hold a multi-turn conversation to
#              demonstrate how threads maintain conversation state
# Context: AI-102 Lab - Agent Service Essentials (Thread Storage)
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

"""
Script 1 — Threads as Conversation State

Demonstrates the core agent workflow: create an agent, open a thread,
exchange messages, and observe how threads preserve conversation context.

In a standard agent setup, threads are stored in Azure Cosmos DB.
In a basic setup, Microsoft manages thread storage internally.

Usage:
    cd AI-102/hands-on-labs/agentic/lab-agent-essentials/terraform
    $env:PROJECT_ENDPOINT = terraform output -raw project_endpoint
    $env:MODEL_DEPLOYMENT_NAME = terraform output -raw model_deployment_name
    cd ../scripts
    python 01_basic_agent.py
"""

import os
import sys

from azure.ai.projects import AIProjectClient
from azure.ai.agents.models import ListSortOrder
from azure.identity import DefaultAzureCredential


def main() -> None:
    """Orchestrate the basic agent and thread demonstration."""

    # Initialize the Foundry project client
    client = create_project_client()

    # Create an agent with specific instructions
    agent = create_agent(client)

    # Create a thread and run a multi-turn conversation
    thread = create_thread(client)
    run_conversation(client, agent.id, thread.id)

    # Display the full conversation history from the thread
    show_thread_history(client, thread.id)

    # Demonstrate thread persistence by retrieving it by ID
    show_thread_retrieval(client, thread.id)

    # Clean up resources
    cleanup(client, agent.id, thread.id)


# Helper Functions
# -------------------------------------------------------------------------

def create_project_client() -> AIProjectClient:
    """
    Create an authenticated AIProjectClient from environment variables.

    Returns:
        AIProjectClient: Authenticated client for the Foundry project
    """

    # Read the project endpoint from the environment
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


def create_agent(client: AIProjectClient) -> object:
    """
    Create an agent with instructions that demonstrate contextual awareness.

    Args:
        client: Authenticated project client

    Returns:
        The created agent object
    """

    # Create the agent with conversational instructions
    agent = client.agents.create_agent(
        model=os.environ.get("MODEL_DEPLOYMENT_NAME", "gpt-4o-mini"),
        name="travel-advisor",
        instructions=(
            "You are a friendly travel advisor. "
            "Remember the user's preferences across the conversation. "
            "When the user mentions a destination, remember it and use it "
            "in later responses. Keep answers concise (2-3 sentences)."
        ),
    )

    print(f"\n--- Agent Created ---")
    print(f"  ID:   {agent.id}")
    print(f"  Name: {agent.name}")
    return agent


def create_thread(client: AIProjectClient) -> object:
    """
    Create a new conversation thread.

    A thread represents a single conversation session.
    All messages in a thread share context, allowing the agent
    to reference earlier parts of the conversation.

    Args:
        client: Authenticated project client

    Returns:
        The created thread object
    """

    thread = client.agents.threads.create()

    print(f"\n--- Thread Created ---")
    print(f"  ID: {thread.id}")
    print(f"  (In standard setup, this is stored in Azure Cosmos DB)")
    return thread


def run_conversation(
    client: AIProjectClient,
    agent_id: str,
    thread_id: str,
) -> None:
    """
    Run a multi-turn conversation to demonstrate thread context persistence.

    Each message builds on the previous one. The agent must remember
    earlier messages to give coherent responses — proving that threads
    maintain state.

    Args:
        client: Authenticated project client
        agent_id: ID of the agent to converse with
        thread_id: ID of the thread to use
    """

    # Define multi-turn conversation messages
    messages = [
        "I'm planning a trip to Japan in April. What should I know?",
        "What's the best city to start in?",
        "How many days should I spend there?",
        "Now suggest a second city based on my interests.",
    ]

    print(f"\n--- Multi-Turn Conversation ---")

    for i, user_message in enumerate(messages, 1):
        print(f"\n  [Turn {i}] User: {user_message}")

        # Add the user's message to the thread
        client.agents.messages.create(
            thread_id=thread_id,
            role="user",
            content=user_message,
        )

        # Run the agent to generate a response
        run = client.agents.runs.create_and_process(
            thread_id=thread_id,
            agent_id=agent_id,
        )

        if run.status == "failed":
            print(f"  Run failed: {run.last_error}")
            continue

        # Get the latest assistant message
        response_messages = client.agents.messages.list(
            thread_id=thread_id,
            order=ListSortOrder.DESCENDING,
        )

        for msg in response_messages:
            if msg.role == "assistant" and msg.run_id == run.id:
                for content in msg.content:
                    if hasattr(content, "text"):
                        print(f"  Agent: {content.text.value}")
                break


def show_thread_history(client: AIProjectClient, thread_id: str) -> None:
    """
    Retrieve and display the complete conversation history from the thread.

    This demonstrates that all messages are persisted in the thread store
    (Cosmos DB in standard setup).

    Args:
        client: Authenticated project client
        thread_id: ID of the thread to retrieve
    """

    print(f"\n--- Full Thread History ---")

    # List messages in chronological order
    messages = client.agents.messages.list(
        thread_id=thread_id,
        order=ListSortOrder.ASCENDING,
    )

    for msg in messages:
        role = msg.role.upper()

        for content in msg.content:
            if hasattr(content, "text"):
                text = content.text.value[:120]
                print(f"  [{role}] {text}...")


def show_thread_retrieval(client: AIProjectClient, thread_id: str) -> None:
    """
    Demonstrate retrieving a thread by ID — proves persistence.

    In production, you would store thread IDs per user session
    and retrieve them later to continue conversations.

    Args:
        client: Authenticated project client
        thread_id: ID of the thread to retrieve
    """

    print(f"\n--- Thread Retrieval ---")

    # Retrieve the thread by its ID
    thread = client.agents.threads.get(thread_id=thread_id)
    print(f"  Retrieved thread: {thread.id}")
    print(f"  Created at: {thread.created_at}")
    print(f"  This proves the thread persists beyond individual requests.")


def cleanup(
    client: AIProjectClient,
    agent_id: str,
    thread_id: str,
) -> None:
    """
    Delete the agent and thread to free resources.

    Args:
        client: Authenticated project client
        agent_id: ID of the agent to delete
        thread_id: ID of the thread to delete
    """

    print(f"\n--- Cleanup ---")

    client.agents.threads.delete(thread_id=thread_id)
    print(f"  Deleted thread: {thread_id}")

    client.agents.delete_agent(agent_id=agent_id)
    print(f"  Deleted agent:  {agent_id}")


# -------------------------------------------------------------------------
# Script Entry Point
# -------------------------------------------------------------------------

if __name__ == "__main__":
    main()
