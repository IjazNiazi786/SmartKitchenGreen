import requests


def get_unsplash_image_urls(query, api_key, num_images=5):
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
        return image_urls
    else:
        # Handle errors
        print(f"Error: {response.status_code}")
        return []


# Replace 'your_api_key_here' with your actual Unsplash API key
API_KEY = 'XXV6FcU2uxQoYWd2IisfQ5GvzBsjxxVZg1pvywpteFU'

# Query for product name
product_name = "Plant Of Parsley"

# Get image URLs
urls = get_unsplash_image_urls(product_name, API_KEY)

# Print the image URLs
for url in urls:
    print(url)
