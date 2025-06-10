# 🛠️ Troubleshooting

This section contains common issues and solutions that you may encounter while using the library. I'll be updating this section as I find new issues or solutions.

## 🚧 Common Issues

### `mouse_x` and `mouse_y` variables are not working after installing the library.

This issue is caused by the library's `mouse_x` and `mouse_y` variables being used in the project. To fix this, you need to change the variable names in the library's scripts. You can do this by removing the library from the project while testing.

It's known that with GUI scale changes the mouse_x and mouse_y variables are not updated correctly. This is a known issue and it's being worked on.

### How can I test async functions with GMTL?

You cannot test async functions with GMTL. This is a known limitation of the library. I'm working on a solution for this, but it's not ready yet and it's not in the priority list unless more people request it.

---

### Cannot run the game after installing the library

This issue can be caused by the library's scripts not being found in the project, or because of the `GMTL_remove_unused` file in some platforms. To fix this, you need to add the library to the project and remove the `GMTL_remove_unused` file from the project if needed.

---

### GMTL_Definitions script file empty after importing in blank project

This issue should be solved since v1.1.0, but if you still encounter it, you can manually copy the contents of the `GMTL_Definitions` script file from the [library's repository](https://github.com/DAndrewBox/GM-Testing-Library/blob/main/GM-Testing-Library/scripts/GMTL_definitions/GMTL_definitions.gml) into your project. This file contains the definitions for the library's functions and is essential for the library to work correctly.

I'm not really sure what causes this issue, but it seems to be related to the import process of the library that GameMaker does. If you encounter this issue, please [create an issue](https://github.com/DAndrewBox/GM-Testing-Library/issues) so I can investigate it further.

---

### Library not found

This error is caused by the library not being found in the project. To fix this, you need to add the library to the project. You can do this by following the installation instructions in the [**Getting Started**](./Getting-Started) section.

---
