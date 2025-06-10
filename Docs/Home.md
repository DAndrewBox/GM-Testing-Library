# GameMaker's Testing Library

> **An open-source testing framework for GameMaker libraries, extensions and prefabs, with a focus on simplicity and ease of use.**

---

## 📖 Table of Contents

- [🔧 Versioning & Compatibility](#-versioning--compatibility)
- [🚀 Getting Started](./Getting-Started)
  - [🌱 Installation](./Getting-Started#-Installation)
  - [⚡ Quick Start](./Getting-Started#-Quick-Start)
- [📚 Documentation](./Documentation)
- [🛠️ Troubleshooting](./Troubleshooting)

---

## 🔧 Versioning & Compatibility

The minimum version of GameMaker required to use this library is **GameMaker 2023.4**. This is because it uses the _string templates_ and _string functions_ introduced in that version like the `string_split()` function. The library should be fully compatible with the latest version of GameMaker 2024.x.

✅: Fully compatible. (\*: Recommended for this version.)

⚠️: Compatible but could have some issues with the new features of the version or built-in functions.

❌: Not compatible.

| GameMaker Version | GMTL v1.0.x | GMTL v1.1.x |
| ----------------: | :---------: | :---------: |
|      Studio 1.4.x |     ❌      |     ❌      |
|    Studio 2 - 2.2 |     ❌      |     ❌      |
|      Studio 2.3.x |     ❌      |     ❌      |
| 2022.x & 2022 LTS |     ❌      |     ❌      |
|   2023.1 - 2023.3 |     ⚠️      |     ❌      |
|  2023.4 - 2023.11 |     ✅      |     ✅      |
|          2023 LTS |     ✅      |     ✅      |
|            2024.x |    ✅\*     |    ✅\*     |

> [!NOTE]
> **Author's comment:** Depending if anyone is interested in using this library with older versions of GameMaker, I could make a version compatible up to **GameMaker Studio 2.3.7** as I did with the compatibility update in the [**GML-Extended**](https://github.com/DAndrewBox/GML-Extended/) library.
