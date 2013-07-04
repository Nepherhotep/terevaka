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

Copy (or clone, or submodule) terevaka into your moai application directory.
Then just import
```local terevaka = require('terevaka/terevaka')```

Terevaka requires host MOAIEnvironment.screenDpi support. Clone my moai fork to ensure it does. It is done at least for Android and iOS.

Applicaction directory structure
---------

 * res/layout -> for layouts built using terevaka-ui-builder
 * res/drawable-h<height>px -> for texture packs with lanscape height <height>, example:
 * res/drawable-h768px -> lanscape height is 768 px


terevaka.TKResourceManager
---------

terevaka.TKResourceManager.loadTexturePack('main') will try to load texture pack 'main.lua' according to best match with res/drawable-h(HEIGHT)px


terevaka.TKLayer
---------

Call layer:fill ({ resourceName='main-layout', texturePack = self.texturePack }) method to populate layer
with sprites from self.texturePack using "res/layout/main-layout.lua" file (file built using terevaka-ui-builder).

Testing multiple devices
---------

Instead of uploading moai on a real device, you can test application appearance by starting moai with appropriate profiles.
```moai terevaka/profiles/ipad.lua main.lua```. See terevaka/profiles/ directory for more profiles, it is extremely easy to add a new one.

Application onCreate/onStart/onResume methods
--------

Use these methods to initialize/release resources on application creation, pausing or resuming

Sample
--------

For more help see https://github.com/Nepherhotep/terevaka-samples
