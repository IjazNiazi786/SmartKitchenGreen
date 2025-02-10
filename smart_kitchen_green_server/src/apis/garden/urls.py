from rest_framework import routers

from src.apis.garden.views import PlantApiView, ProductRecommendationOnLocationAPI

from django.urls import  path, include

app_name='garden'
route = routers.DefaultRouter()

route.register(r'plant',PlantApiView)

urlpatterns=[

    path('',include(route.urls)),
    path(
        'location/<str:longitude>/<str:latitude>/<str:address>/<str:is_more>/',
        ProductRecommendationOnLocationAPI.as_view(), name='recommendation-on-location'
    ),

]