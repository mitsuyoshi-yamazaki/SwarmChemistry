# SwarmChemistry

Swift library of Hiroki Sayama's artificial chemistry model [SwarmChemistry](http://bingweb.binghamton.edu/~sayama/SwarmChemistry/), and its app implementations for iOS, macOS and screensaver for Mac.

<img width="720" src="https://user-images.githubusercontent.com/904354/29809092-b9351970-8cd5-11e7-8961-0444773cbfed.gif">

# Requirement

iOS10+<br>
macOS10.12+

# Usage

- [Install to Your App](#user-content-yourapp)
- [Run Demo Apps](#user-content-demoapp)
- [Install Screensaver](#user-content-screensaver)
 
## <a name="yourapp"></a>Install to Your App

Use Carthage 

```
github "mitsuyoshi-yamazaki/SwarmChemistry"
```

## <a name="demoapp"></a>Run Demo Apps

Open this project on Xcode8.3, choose scheme Demo_iOS or Demo_Mac and run.

on **iOS app**, you can choose several recipes, random recipe and input your own recipe as text.
You can also *share* current recipe and current screenshot of the swarm.
When you *share* recipe while zooming in to a pattern, the recipe represents the pattern, not the whole swarm.

on **Mac app**, you can not choose recipe on the app for now, so modify source code to change recipe by changing `Population` parameter in `setup()` method in `Demo_Mac/ViewController.swift`.


## <a name="screensaver"></a>Install Screensaver

Download screensavers from [Releases](#user-content-releases), unzip them and double-click to install.

# <a name="releases"></a>Releases

See [Releases](https://github.com/mitsuyoshi-yamazaki/SwarmChemistry/releases/)
