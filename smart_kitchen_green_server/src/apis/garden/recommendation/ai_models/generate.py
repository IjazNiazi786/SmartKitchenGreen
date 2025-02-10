import google.generativeai as genai

from core import settings


def generate_response(address, date):
    genai.configure(api_key=settings.API_KEY)

    model = genai.GenerativeModel('gemini-1.5-flash')

    prompt = f"""
    Please provide a list of 20 plants that are optimal for growing in {address} on the date {date}. 
    The response should be in JSON format, with each plant represented by an object containing the following fields:
    - name: The name of the plant.
    - category: The type or category of the plant (e.g., herb, vegetable, fruit, etc.).
    - bestgrow: Specifies whether the plant grows best indoors or outdoors.
    - watertime: The time in hours after which the plant needs to be watered. For example, if the plant needs water every 2 days, this should be 48 hours, and if it needs water every 3 days, it should be 72 hours.

    The JSON response should be structured as follows:
    plants = [
      {{
        "name": "plant_name",
        "category": "plant_category",
        "bestgrow": "indoor/outdoor",
        "water_time": water_time_in_hours
      }},
      ...
    ]
    """

    response = model.generate_content(prompt)
    return response.text
