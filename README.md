Terevaka
========

Application framework for moai.

Terevaka framework aims to solve just several problems:

1. Screen density fragmentation
2. Screen size fragmentation
3. GUI layout builder

Since it is a framework, it will implement convenient application structure.

Also you could notice that many things implemented in a way you already saw in Android native applications. Really, why not? :)

Installation
---------

Copy (or clone, or submodule) terevaka into your moai directory.
Then just import
```local terevaka = require('terevaka/terevaka')```

Terevaka requires host MOAIEnvironment.screenDpi support. Clone my moai fork to ensure it does. It is done at least for Android and iOS.

Applicaction directory structure
---------

 * res/layout -> for layouts built using terevaka-ui-builder
 * res/drawable-mdpi -> for texture packs
 * res/drawable-xhdpi -> for HD texture packs


terevaka.TKResourceManager
---------

terevaka.TKResourceManager.loadTexturePack('main') will try to load texture pack 'main.lua' which is in res/drawable-mdpi or xhdpi depending on current screenDpi.
Attention! Both of mdpi and xhdpi texture packs required.


terevaka.TKScreen
---------

Two the most important functions of the framework dipToPix and pixToDip. They convert coordinates from dips to scene and vice versa.


terevaka.TKScene
---------

Transitions between scenes are not implemented yet, but TKScene is still useful. Call self:fillLayer(self.layer, self.texturePack, 'main-layout') method to populate self.layer
with sprites from self.texturePack using "res/layout/main-layout.lua" file (file built using terevaka-ui-builder).

Testing multiple devices
---------

Instead of uploading moai on a real device, you can test application appearance by starting moai with appropriate profiles.
```moai terevaka/profiles/ipad.lua main.lua```. See terevaka/profiles/ directory for more profiles, it is extremely easy to add a new one.

Application onCreate/onStart/onResume methods
--------

They a done as a prototype. All of them are called on application start. onPause/onResume events are not implemented yet, but will be added in the nearest future.
