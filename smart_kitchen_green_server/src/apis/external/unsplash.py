import requests

from core.settings import UNSPLASH_API_KEY


def get_unsplash_image_urls(query, num_images=1):
    api_key =UNSPLASH_API_KEY
    # Unsplash API endpoint for searching photos
    url = "https://api.unsplash.com/search/photos"

    # Parameters for the API request
    params = {
        "query": query,
        "client_id": api_key,
        "per_page": num_images
    }

    # Make the GET request to the Unsplash API
    response = requests.get(url, params=params)

    # Check if the request was successful
    if response.status_code == 200:
        # Parse the JSON response
        data = response.json()
        # Extract image URLs from the response
        image_urls = [photo['urls']['regular'] for photo in data['results']]
        return image_urls[0]
    else:
        # Handle errors
        print(f"Error: {response.status_code}")
        return []
