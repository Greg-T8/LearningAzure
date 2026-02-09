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
import json
import requests
from pathlib import Path
from datetime import datetime

# Configuration (replace with your values or set environment variables)
ENDPOINT = os.environ.get("AZURE_OPENAI_ENDPOINT", "https://your-endpoint.openai.azure.com/")
API_KEY = os.environ.get("AZURE_OPENAI_API_KEY", "your-api-key")
DEPLOYMENT_NAME = os.environ.get("DALLE_DEPLOYMENT_NAME", "deploy-dalle3")
API_VERSION = "2024-02-15-preview"

# Output directory
OUTPUT_DIR = Path("generated-images")
OUTPUT_DIR.mkdir(exist_ok=True)


def generate_image(prompt: str, size: str = "1024x1024") -> dict:
    """
    Generate an image using DALL-E 3.

    Args:
        prompt: Text description of the image to generate
        size: Image size (1024x1024, 1792x1024, or 1024x1792)

    Returns:
        Dictionary containing the API response
    """
    url = f"{ENDPOINT}/openai/deployments/{DEPLOYMENT_NAME}/images/generations"

    headers = {
        "api-key": API_KEY,
        "Content-Type": "application/json"
    }

    params = {
        "api-version": API_VERSION
    }

    body = {
        "prompt": prompt,
        "size": size,
        "n": 1,
        "quality": "standard",
        "style": "vivid"
    }

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
    response = requests.get(image_url)
    response.raise_for_status()

    filepath = OUTPUT_DIR / filename
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
    with open(filepath, "rb") as f:
        header = f.read(4)

    # Check for PNG signature
    if header[:4] == b'\x89PNG':
        return "PNG"

    # Check for JPEG signature
    if header[:2] == b'\xff\xd8':
        return "JPEG"

    return "Unknown"


def main():
    """Main test function."""
    print("\n=== DALL-E 3 Image Generation Test (Python) ===\n")
    print(f"Endpoint: {ENDPOINT}")
    print(f"Deployment: {DEPLOYMENT_NAME}\n")

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

    # Exam question analysis
    print("\n=== Exam Question Analysis ===\n")
    print("Statement 1: Prefilled Python code reflecting your settings is available")
    print("  Answer: YES - This script demonstrates the code available in Azure AI Foundry\n")
    print("Statement 2: You can set the size of the generated images to 1024x1024")
    print("  Answer: YES - DALL-E 3 supports 1024x1024, 1792x1024, and 1024x1792\n")
    print("Statement 3: You can save generated images in JPEG format")
    print("  Answer: NO - DALL-E 3 generates images in PNG format only")
    print("  Note: You can convert PNG to JPEG after download if needed\n")

    print(f"Generated images saved to: {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
