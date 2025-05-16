# 💡 How Do We Use Git and TCL to Reconstruct Our Vivado Projects?

**Have you ever faced the following situation ?** 
You’ve been working on an FPGA project for weeks — maybe even months — writing countless lines of VHDL or Verilog code. You’ve spent hours troubleshooting cryptic errors in IDEs that rarely point you to the exact issue. And now, all you wish is that you still had that one old version of your code… the one that actually worked.

Unfortunately, FPGA development environments aren't exactly user-friendly. It's quite common to run into problems when trying **to version your code** or even just **rebuilding it**. If you try to use *Git* the same way you do in typical software projects, you'll quickly end up with a repository full of thousands of files—and even a simple git push can feel like it takes a lifetime.

**What if I told you *Git* doesn’t need to track all those files?** You can version only the essential source files—and that’s enough to automatically rebuild your entire project on another machine.

## 🛠️ Setting up Your Project
Let's start with the basics: creating you project ! For this tutorial, I’ll be using the Vivado IDE from Xilinx (now AMD), but you can likely follow similar steps in Quartus from Intel (formerly Altera).

First, open your IDE and click on Create Project. Go through the setup steps, choosing a suitable name and directory for your project. Avoid using spaces or special characters in project names or folder paths—they can cause issues later on.

If you’re using Windows, make sure you have [*Git installed*](https://git-scm.com/) on your system. 

If you plan to store your code in a cloud repository like **GitHub** or **GitLab**, create a new repository online and copy its clone URL.

Then, open a terminal, navigate to your project directory, and initialize your *Git* environment:

```bash
git init
git config user.name "Name"
git config user.email "Email@gmail.com"
git branch -M main
git remote add name URL
```

## 📄 Creating your `.gitignore`


This is the **hot spot** to version your FPGA projects. The `.gitignore` file lets us control which files and folders are tracked by Git — even in directories that contain many other generated or temporary files.

It's important to understand that **each project should have its own tailored `.gitignore`**, so don't treat this one as a one-size-fits-all solution. During development, it's a good idea to regularly run `git status` to check which files and folders are currently being tracked.

For example, in this **Blink project**, my folder structure looks like:
```
Blink/
├── Blink.cache/
├── Blink.hw/
├── Blink.ip_user_files/
├── Blink.runs/
├── Blink.sim/
├── Blink.srcs/
├── .github
├── .gitignore
└── Blink.xpr
```

However, the only folder that really matters here is the `Blink.srcs`.  
So, in my `.gitignore`, I wrote the following:

``` gitignore

#Auto-generated folders
Blink.cache/
Blink.hw/
Blink.ip_user_files/
Blink.runs/
Blink.sim/

#Auto-generated files
Blink.xpr

#Files
Blink.srcs/sources_1/ip/ila_0/*
!Blink.srcs/sources_1/ip/ila_0/*.xml
!Blink.srcs/sources_1/ip/ila_0/*.xci
```
Normally, inside a `project.srcs` folder, you will find:

- Constraint files (e.g., `.xdc`)
- HDL sources that you wrote
- Imported IP cores (e.g., `.xci`)
- Other generated or user-imported files

In this example, the structure looks like this:

```
Blink.srcs/
├── constrs_1/
│   └── new/
└── sources_1/
    ├── imports/
    ├── ip/
    └── new/
```
> ⚠️ **Attention:** Sometimes IP cores may contain a lot of ignorable files. The only two necessary files are those with the extensions **`.xml`** and **`.xci`**. To see how to keep only these files, refer to the `.gitignore` example above.

## 💻 Generating TCL Script
Sometimes during development, we need to work across different machines, and manually recreating and reconfiguring everything from scratch can be very unproductive.

That’s where TCL scripts come in — they play a key role in automating the project setup. With a properly written script, you can rebuild your entire Vivado project using only the source files.

That’s exactly why we version only the essential files: to make regeneration fast, clean, and consistent.

After finishing your development, you’ll generate your TCL script — just like shown in the image below:

![Generate TCL](.github\img\TCL.png)

A window will pop up allowing you to choose the directory where you’d like to save the TCL script.

![Save TCL](.github\img\Directory.png)

I recommend choosing the **root of your project** — that is, the directory where folders like `.gitignore`, `project.srcs`, and others are located.

>⚠️ **Attention:** If you're using Block Designs, make sure to check the option **"Recreate Block Designs using TCL"** when exporting the script.


Right after this dialog, the script will be generated.  
By default, Vivado will use the path where it is installed as the working directory.  

To fix this, open your `.tcl` file and search for the line that contains:

```tcl
set origin_dir "."
```
At first, this looks fine - since "." means the current directory. But be careful - this is a trap! Vivado may still resolve `"."` relative to its own internal path, not your project root.

To ensure the script runs correctly across different machines, replace the line with:

```tcl
set origin [pwd]
```

> 🧠 **Remember:** the `.tcl` file must be in the version control as well !

## 🚀 Using TCL Script
At this stage, your versioned repository is expected to resemble the following structure:

```
Project/
├── Project.srcs/
├── Project.tcl
├── .gitignore
└── README.md
```

Now, on a different machine, you can clone the repository using the following command:

``` bash
git clone URL
```

Once the repository is cloned, open **Vivado**. Click on *Run Tcl Script*, locate your `.tcl` file, and… watch the magic happen ✨ 

![Run TCL Script](.github\img\Run.png)

If you run into an issue that requires re-running the TCL script, you might see an error like:

> *Error: Project already exists.*

To fix this, open your `.tcl` script, find the line that starts with `create_project`, and add the `-force` flag to it. 