# 🛠️ Troubleshooting

This section contains common issues and solutions that you may encounter while using the library. I'll be updating this section as I find new issues or solutions.

## 🚧 Common Issue

### mouse_x and mouse_y are not working after installing the library

This issue is caused by the library's `mouse_x` and `mouse_y` variables being used in the project. To fix this, you need to change the variable names in the library's scripts. You can do this by removing the library from the project while testing.

It's known that with GUI scale changes the mouse_x and mouse_y variables are not updated correctly. This is a known issue and it's being worked on.

---

### Cannot run the game after installing the library

This issue can be caused by the library's scripts not being found in the project, or because of the `GMTL_remove_unused` file in some platforms. To fix this, you need to add the library to the project and remove the `GMTL_remove_unused` file from the project if needed.

---

### Library not found

This error is caused by the library not being found in the project. To fix this, you need to add the library to the project. You can do this by following the installation instructions in the [**Getting Started**](./Getting-Started) section.

---
