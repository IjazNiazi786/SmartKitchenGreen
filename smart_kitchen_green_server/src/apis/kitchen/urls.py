from django.urls import include, path
from rest_framework import routers

from src.apis.kitchen.views import ProductApiView ,ApplianceApiView

app_name = 'kitchen'

route = routers.DefaultRouter()

route.register(r'product', ProductApiView)
route.register(r'appliance', ApplianceApiView)

urlpatterns = [
    path('', include(route.urls))

]
