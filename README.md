# PhoneShopTestTask
test task phone store app.   
The MVVM architecture was used when building the application
## [figma](https://www.figma.com/file/KqZcU5m3GMxAHwgFkvCONz/ECOMMERCE?node-id=2%3A845)

# Basic requirements for the terms of reference
## Main screen
### select category
* When you click on the icon, it changes color (as by design). Only one icon can be selected and highlighted.
### Hot sales 
* carousel of elements.
### Best seller 
* Product list in the form of a collection.

![](/screenshots/mainScreen.gif)

### Filter options 
* Drop-down list of brand, size and price. Size - only draw as in Figma.

![](/screenshots/filterOptions.gif "work filter options")

## Product details screen
* Shows only one phone model (limitations of the provided API).
* Product images in the form of a carousel.

![](/screenshots/detailsProduct.gif "product details")

When you click the add to cart button, the device that was selected on the main screen is added to the cart

## My Cart screen
* The user sees a list of added products in the cart.
* The screen shows the final price for all the added devices.
* The location and checkout buttons are not activated

Since according to the technical specification, the initial data is taken on request from the issued API, adding products from the main screen starts working after opening the my cart screen.

![](/screenshots/myCart.gif "my cart screen")

## Presentation of the application

![](/screenshots/app.gif)
