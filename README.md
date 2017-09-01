# SwarmChemistry

Swift library of Hiroki Sayama's artificial chemistry model [SwarmChemistry](http://bingweb.binghamton.edu/~sayama/SwarmChemistry/). 
This project includes followings:

- SwarmChemistry library
- Demo app implementation for iOS
- Demo app implementation for macOS
- Screensaver for Mac

<img width="720" src="https://user-images.githubusercontent.com/904354/29809092-b9351970-8cd5-11e7-8961-0444773cbfed.gif">

# Requirement

iOS10+<br>
macOS10.12+

# Usage

- [Install to Your App](#yourapp)
- [Run Demo Apps](#demoapp)
- [Install Screensaver](#screensaver)
 
## <a name="yourapp"></a>Install to Your App

Use Carthage:

```Cartfile
github "mitsuyoshi-yamazaki/SwarmChemistry"
```

To use the library, see: [implementation](Playground.playground/Contents.swift)


## <a name="demoapp"></a>Run Demo Apps

#### 1. Clone this repository

```shell
$ git clone git@github.com:mitsuyoshi-yamazaki/SwarmChemistry.git
```

#### 2. Open the project

Open `SwarmChemistry.xcworkspace` on Xcode8.3


#### 3. Run the app

Choose a scheme Demo_iOS or Demo_Mac and run.

<img width=400 src="https://user-images.githubusercontent.com/904354/29957641-87c3e780-8f29-11e7-8936-ff46020f6178.png">

#### About iOS app

- You can choose initial swarm condition: 
	- Predefined recipes
	- Random
	- Manual input
- You can share the current recipe and screenshot

<br>
<img width=320 src="https://user-images.githubusercontent.com/904354/29957998-7f25b124-8f2b-11e7-8d2e-eb847fdf9e49.jpg">


#### About Mac app

- You can not choose recipe on the app for now, so edit recipe by changing `Population` parameter in the [source code](Demo_Mac/ViewController.swift#L86)

## <a name="screensaver"></a>Install Screensaver

Download screensavers from [Releases](#releases), unzip them and double-click to install.

# Content


This project includes following targets:

|Target name|Description|
|:--|:--|
|SwarmChemistry_iOS|SwarmChemistry CocoaTouch Framework|
|SwarmChemistry_Mac|SwarmChemistry Cocoa Framework|
|SwarmChemistryTest_iOS|Tests for SwarmChemistry|
|SwarmChemistryTest_Mac|Tests for SwarmChemistry|
|Demo_iOS|App implementation for iOS|
|Demo_Mac|App implementation for Mac|
|Demo_Screensaver|Screensaver for Mac|
|AtHome|ArtificialLife@home (Screensaver for Mac)|

# <a name="releases"></a>Releases

See [Releases](https://github.com/mitsuyoshi-yamazaki/SwarmChemistry/releases/)
