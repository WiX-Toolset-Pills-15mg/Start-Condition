# Start Condition

## Overview

Sometimes we must check some condition before proceeding with the installation of a product.

WiX Toolset offers the `<Condition>` element that can help us in this scenario.

## Prerequisite

Create a WiX Toolset installer project that deploys a single file.

- See the [My First Installer](https://github.com/WiX-Toolset-Pills-15mg/My-First-Installer) tutorial for an example.

## Step 1 - Create the `ALLOW_TO_INSTALL` property

First of all, let's create a simple "public" property called `ALLOW_TO_INSTALL`:

```xml
<Property Id="ALLOW_TO_INSTALL" Value="yes" />
```

This property will be used, later, in the condition expression that will decide if the installation is allowed.

**Note:** The property is all upper case, in order to be considered "public" and allow us to pass it from command line.

## Step 2 - Create the `<Condition>` element

Let's take an example:

```xml
<Condition Message="Sorry, you are not allowed to install the product.">
    <![CDATA[ALLOW_TO_INSTALL = "yes"]]>
</Condition>
```

The way the condition works in WiX Toolset may be a little bit unintuitive. For example, the first time I wrote a condition in WiX Toolset, I was expecting to write the condition for stopping the installer. I was thinking like in C# where, in a similar situation I write the condition and throw an exception if it is not fulfilled, in order to stop the execution of the use case.

### The `LaunchConditions` custom action

On the other hand, in WiX Toolset, we, usually, don't write the instructions ourselves. Instead, we configure the execution of some already existing modules. In our particular situation the job of checking the start conditions is performed by the `LaunchConditions` custom action included automatically by WiX Toolset in the execution sequence. We just need to configure that custom action and we do that with the `<Condition>` element.

This custom action is included at the beginning of the installation sequence:

```
Line 225: Action start 07:53:22: INSTALL.
Line 232: Action start 07:53:22: FindRelatedProducts.
Line 237: Action start 07:53:22: LaunchConditions.
```

It will evaluate the provided expression and stop the execution if it is `false`.

### The condition expression

The body of the `<Condition>` element contains the condition itself that must be fulfilled in order for the installer to proceed further. In our example we used the `ALLOW_TO_INSTALL` property and we allow to proceed only if it has the value `yes`.

### The message

The `Message` attribute contains the text displayed to the user when the condition is not fulfilled.

## Step 3 - Compile and run

After compile, run the installer:

```
msiexec /i StartCondition.msi /l*vx install.log ALLOW_TO_INSTALL=no
```

This will set the `ALLOW_TO_INSTALL` property to `no` and the installer will display a popup with the `Sorry, you are not allowed to install the product.` message.

## Final Notes

The actual start condition verifications can be calculated by an immediate custom action written in C#. This gives us the whole power of the C# for verifying the actual start conditions. The result, then, should be set in a WiX property and used in the WiX condition as shown in this tutorial.

Just make sure to schedule your custom action before the `LaunchConditions`, in both `InstallUISequence` and  `InstallExecuteSequence`:

```xml
<InstallUISequence>
	<Custom Action="SomeVerifications" Before="LaunchConditions"></Custom>
</InstallUISequence>

<InstallExecuteSequence>
	<Custom Action="SomeVerifications" Before="LaunchConditions"></Custom>
</InstallExecuteSequence>
```

