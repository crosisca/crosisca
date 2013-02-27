/***************************************************************************************************
* IMPORTANT NOTE
****************************************************************************************************/

The Cannon Combat game is built with two distinct projects that use the same code base.
The first version (dev) runs in AIR 2 for testing purposes and will run on your workstation.
The second version (prod) runs on the specified mobile device supported by Flash Builder 4.5.

In order to share the same common source package, both projects have an external source folder added in Project -> Properties -> Flex Build Path -> Source Path

Therefore, they differentiate in their Default Application mxml file only and obviously, descriptors.

This project requires the Flex SDK 4.6, otherwise, you will need to add two SWC files ( mobilecomponents.swc and mobile.swc) manually through Project -> Properties -> Flex Build Path -> Library Path for the dev version only. These two SWC files can be found in the Flex SDK 4.6.

If after including both SWC files as described above, the theme “Mobile” doesn't appear under the option Flex Theme in the project settings, please add it manually.

For the prod version, you will also need a .p12 certificate and a .mobileprovision file in order to deploy to iOS devices (this is not required for Android). Please see the following link for detailed instructions on how to provision for iOS and the App Store:

http://www.adobe.com/devnet/air/articles/packaging-air-apps-ios.html 

Since we use SDK 4.6, the descriptor's application tag uses version 3.1, as below:

<application xmlns="http://ns.adobe.com/air/application/3.1">

