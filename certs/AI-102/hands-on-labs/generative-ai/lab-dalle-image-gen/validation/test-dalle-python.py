# -------------------------------------------------------------------------
# Program: test-dalle-python.py
# Description: Python example for DALL-E 3 image generation
# Context: AI-102 Lab - Generate and manipulate images with DALL-E
# Author: Greg Tate
# Date: 2026-02-09
# -------------------------------------------------------------------------

"""
Python script demonstrating DALL-E 3 image generation with Azure OpenAI.
This shows the "prefilled code" experience available in Azure AI Foundry.
"""

import os
import sys
import argparse
import subprocess
import requests
from pathlib import Path
from datetime import datetime

# Global configuration
config = {
    "endpoint": None,
    "api_key": None,
    "deployment_name": None,
    "api_version": "2024-02-15-preview",
    "output_dir": None
}

def main() -> None:
    """Main test function."""
    # Parse command-line arguments
    args = parse_arguments()

    # Initialize configuration from arguments or Terraform
    initialize_configuration(args)

    # Run DALL-E generation tests
    test_dalle_generation()

    # Display exam answer summary
    show_exam_answer_summary()


# Helper Functions
# -------------------------------------------------------------------------

def parse_arguments() -> argparse.Namespace:
    """
    Parse command-line arguments.

    Returns:
        argparse.Namespace: Parsed arguments
    """
    parser = argparse.ArgumentParser(
        description='Test DALL-E 3 image generation with various sizes and formats'
    )

    parser.add_argument(
        '--endpoint',
        help='Azure OpenAI endpoint URL',
        default=None
    )

    parser.add_argument(
        '--api-key',
        help='Azure OpenAI API key',
        default=None
    )

    parser.add_argument(
        '--deployment-name',
        help='DALL-E deployment name',
        default=None
    )

    parser.add_argument(
        '--output-dir',
        help='Output directory for generated images',
        default='generated-images'
    )

    return parser.parse_args()


def initialize_configuration(args: argparse.Namespace) -> None:
    """
    Initialize configuration from arguments or Terraform outputs.

    Args:
        args: Parsed command-line arguments
    """
    # Set output directory
    config["output_dir"] = Path(args.output_dir).resolve()
    config["output_dir"].mkdir(exist_ok=True)

    # Check if configuration should be retrieved from Terraform
    if not args.endpoint or not args.api_key or not args.deployment_name:
        print("Retrieving configuration from Terraform outputs...")
        retrieve_terraform_config()

    # Override with any provided arguments
    if args.endpoint:
        config["endpoint"] = args.endpoint
    if args.api_key:
        config["api_key"] = args.api_key
    if args.deployment_name:
        config["deployment_name"] = args.deployment_name

    # Validate configuration
    if not all([config["endpoint"], config["api_key"], config["deployment_name"]]):
        print("Error: Missing required configuration.")
        print("Provide --endpoint, --api-key, and --deployment-name,")
        print("or ensure Terraform outputs are available in ../terraform")
        sys.exit(1)


def retrieve_terraform_config() -> None:
    """
    Retrieve configuration from Terraform outputs.

    Executes terraform output commands in the ../terraform directory
    to get the Azure OpenAI configuration.
    """
    # Navigate to terraform directory
    terraform_dir = Path(__file__).parent.parent / "terraform"

    if not terraform_dir.exists():
        print(f"Warning: Terraform directory not found at {terraform_dir}")
        return

    try:
        # Retrieve OpenAI endpoint
        result = subprocess.run(
            ["terraform", "output", "-raw", "openai_endpoint"],
            cwd=terraform_dir,
            capture_output=True,
            text=True,
            check=True
        )
        config["endpoint"] = result.stdout.strip()

        # Retrieve OpenAI API key
        result = subprocess.run(
            ["terraform", "output", "-raw", "openai_primary_key"],
            cwd=terraform_dir,
            capture_output=True,
            text=True,
            check=True
        )
        config["api_key"] = result.stdout.strip()

        # Retrieve deployment name
        result = subprocess.run(
            ["terraform", "output", "-raw", "image_deployment_name"],
            cwd=terraform_dir,
            capture_output=True,
            text=True,
            check=True
        )
        config["deployment_name"] = result.stdout.strip()

    except subprocess.CalledProcessError as e:
        print(f"Warning: Failed to retrieve Terraform outputs: {e}")
    except FileNotFoundError:
        print("Warning: Terraform command not found. Please install Terraform or provide configuration manually.")


def test_dalle_generation() -> None:
    """
    Test DALL-E 3 image generation with various sizes.
    """
    print("\n=== DALL-E 3 Image Generation Test (Python) ===\n")
    print(f"Endpoint: {config['endpoint']}")
    print(f"Deployment: {config['deployment_name']}\n")

    # Test cases with different sizes
    test_cases = [
        {
            "name": "Standard 1024x1024",
            "size": "1024x1024",
            "prompt": "A serene mountain landscape at sunset with a crystal-clear lake reflecting the sky"
        },
        {
            "name": "Wide 1792x1024",
            "size": "1792x1024",
            "prompt": "A futuristic city skyline with flying cars and neon lights"
        },
        {
            "name": "Tall 1024x1792",
            "size": "1024x1792",
            "prompt": "A tall lighthouse on a rocky cliff overlooking the ocean during a storm"
        }
    ]

    # Iterate through each test case
    for test in test_cases:
        print(f"Testing: {test['name']}")
        print(f"  Size: {test['size']}")
        print(f"  Prompt: {test['prompt']}")

        try:
            # Generate image
            result = generate_image(test['prompt'], test['size'])

            # Get image URL
            image_url = result['data'][0]['url']
            print(f"  Status: Success")
            print(f"  Image URL: {image_url}")

            # Download image
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            size_str = test['size'].replace('x', '_')
            filename = f"dalle_{size_str}_{timestamp}.png"

            filepath = download_image(image_url, filename)
            print(f"  Saved: {filepath}")

            # Check format
            format_name = check_image_format(filepath)
            print(f"  Format: {format_name} (verified)")

        except Exception as e:
            print(f"  Status: Failed")
            print(f"  Error: {str(e)}")

        print()

    # Display completion message
    print(f"Generated images saved to: {config['output_dir']}")


def show_exam_answer_summary() -> None:
    """
    Display exam question analysis and answers.
    """
    # Display exam question analysis
    print("\n=== Exam Question Analysis ===\n")
    print("Statement 1: Prefilled Python code reflecting your settings is available")
    print("  Answer: YES - Azure AI Foundry portal provides code snippets in multiple languages\n")
    print("Statement 2: You can set the size of the generated images to 1024x1024")
    print("  Answer: YES - DALL-E 3 supports 1024x1024, 1792x1024, and 1024x1792\n")
    print("Statement 3: You can save generated images in JPEG format")
    print("  Answer: NO - DALL-E 3 generates images in PNG format only")
    print("  Note: You can convert PNG to JPEG after download if needed\n")

def generate_image(prompt: str, size: str = "1024x1024") -> dict:
    """
    Generate an image using DALL-E 3.

    Args:
        prompt: Text description of the image to generate
        size: Image size (1024x1024, 1792x1024, or 1024x1792)

    Returns:
        Dictionary containing the API response
    """
    # Construct API endpoint URL
    url = f"{config['endpoint']}/openai/deployments/{config['deployment_name']}/images/generations"

    # Set request headers
    headers = {
        "api-key": config["api_key"],
        "Content-Type": "application/json"
    }

    # Set API version parameter
    params = {
        "api-version": config["api_version"]
    }

    # Build request body with generation parameters
    body = {
        "prompt": prompt,
        "size": size,
        "n": 1,
        "quality": "standard",
        "style": "vivid"
    }

    # Send request and validate response
    response = requests.post(url, headers=headers, params=params, json=body)
    response.raise_for_status()

    return response.json()


def download_image(image_url: str, filename: str) -> Path:
    """
    Download an image from a URL.

    Args:
        image_url: URL of the image to download
        filename: Name to save the file as

    Returns:
        Path to the saved file
    """
    # Download image from URL
    response = requests.get(image_url)
    response.raise_for_status()

    # Save image to file
    filepath = config["output_dir"] / filename
    filepath.write_bytes(response.content)

    return filepath


def check_image_format(filepath: Path) -> str:
    """
    Check the format of an image file by reading its header bytes.

    Args:
        filepath: Path to the image file

    Returns:
        Format name (PNG, JPEG, or Unknown)
    """
    # Read file header bytes
    with open(filepath, "rb") as f:
        header = f.read(4)

    # Check for PNG signature
    if header[:4] == b'\x89PNG':
        return "PNG"

    # Check for JPEG signature
    if header[:2] == b'\xff\xd8':
        return "JPEG"

    return "Unknown"


# -------------------------------------------------------------------------
# Script Entry Point
# -------------------------------------------------------------------------

if __name__ == "__main__":
    main()
