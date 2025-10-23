<!-- TOC start (generated with https://github.com/derlin/bitdowntoc) -->

- [Merge Directories](#merge-directories)
   * [Features](#features)
   * [Installation](#installation)
   * [Requirements](#requirements)
   * [Usage](#usage)
      + [Syntax](#syntax)
      + [Options](#options)
      + [Examples](#examples)
   * [🧪 Example of use with the `sandbox` directory](#-example-of-use-with-the-sandbox-directory)
      + [📁 Example structure](#-example-structure)
      + [▶️ Example 1: Renaming generic photos](#%EF%B8%8F-example-1-renaming-generic-photos)
   * [Behavior](#behavior)
      + [Duplicate files](#duplicate-files)
      + [Hidden files](#hidden-files)
      + [Automatic cleanup](#automatic-cleanup)
   * [Script output](#script-output)
      + [Normal output](#normal-output)
      + [Debug mode output (-d)](#debug-mode-output-d)
   * [Validations](#validations)
   * [Warnings](#warnings)
   * [Troubleshooting](#troubleshooting)
      + [Error: “The destination already exists”](#error-the-destination-already-exists)
      + [Error: “You do not have read permissions”](#error-you-do-not-have-read-permissions)
      + [Files are not being moved](#files-are-not-being-moved)
   * [Contribute](#contribute)
   * [License](#license)
   * [Author](#author)

<!-- TOC end -->

# Merge Directories

English | [Spanish](README.es.md)

Bash script to merge multiple directories into one, ideal for consolidating backups from mobile phones or other devices that share a directory structure.

> 💬 **Author's note**  
> My knowledge of Bash is limited, and I have tried to keep the code as clear and understandable as possible.  
> Even so, it may contain errors or parts that could be improved.  
> Suggestions and pull requests that help improve the clarity or reliability of the script are welcome.


## Features

- 🔀 Merges multiple directories while maintaining the tree structure
- 📦 Moves or copies files according to preference
- 🔍 Includes hidden files
- ⚡ Automatically ignores duplicates (keeps the first file found)
- 📊 Displays detailed statistics of the process
- 🧹 Cleans empty directories after moving files
- 🐛 Debug mode for detailed tracking
- ✅ No external dependencies


## Installation

```bash
# Clone repo
git clone https://github.com/hunzaGit/merge-directories.git
# or download the script
curl -O https://github.com/hunzaGit/merge-directories/main/merge_dirs.sh

# Give execution permissions
chmod +x merge_dirs.sh
```


## Requirements

- **Bash** 3.2+ (included in macOS by default)
- Read permissions on source directories
- Write permissions on destination location
- Unusual characters such as “[”, “]” are not supported. Valid name “Backup OP 5T 2020-01-10”

## ⚠️ Tested compatibility
### MacOS
Tested on **macOS 14.6.1 (Apple Silicon)** 
Verified with both local files on SSD and files on an SMB network drive connected from a **Windows 10** computer on the local network.  

### Linux (Ubuntu, Debian) or CentOS/Fedora
Operation has not been verified on **Linux**, **CentOS**, or other operating systems, so additional adjustments may be required (e.g., paths, permissions, or differences in command output).



## Usage

### Syntax

```bash
./merge_dirs.sh [-c] [-d destination] [-v] directory1 directory2 [directory3 ...]
```

### Options

| Option | Description |
|--------|-------------|
| `-c` | Copy files instead of moving them. Default |
| `-c` | Move files instead of copying them |
| `-o <destination>` | Specify destination directory (default: `merge`) |
| `-d` | Debug mode: show detailed logs of the process |
| `-f` | Forces the destination directory name if it already exists |
| `-h` | Show help |


### Examples

**Typical use case: Merging mobile backups**

```bash
./merge_dirs.sh Backup1 Backup2 Backup3
```

**Structure before:**
```
Backup1/
├── DCIM/Camera/photo1.jpg
└── Music/song1.mp3

Backup2/
├── DCIM/Camera/photo2.jpg
└── Documents/doc1.pdf

Backup3/
└── DCIM/Screenshots/screen1.png
```

**Structure after:**
```
resultMerge/
├── DCIM/
│   ├── Camera/
│   │   ├── photo1.jpg
│   │   └── photo2.jpg
│   └── Screenshots/screen1.png
├── Music/song1.mp3
└── Documents/doc1.pdf
```

**Copy instead of move (keep original backups):**

```bash
./merge_dirs.sh -c Backup1 Backup2 Backup3
```

**Specify custom destination:**

```bash
./merge_dirs.sh -o UnifiedBackup2024 Backup1 Backup2
```

**Debug mode for detailed tracking:**

```bash
./merge_dirs.sh -d Backup1 Backup2
```

**Combine options:**

```bash
./merge_dirs.sh -c -d -o MyBackup Backup1 Backup2 Backup3
```


## 🧪 Example of use with the `sandbox` directory

The repository includes a `sandbox/` directory with examples ready to test the script's functionality without using your own photos.

### 📁 Example structure
```
sandbox/
├── test1/
│ ├── .hiddenDir/
│ │ └── img.jpg
│ ├── DCIM/
│   └── Camera/
│     ├── photo1.jpg
│     └── photo2.jpg
├── test2/
│ ├── DCIM/
│   └── Camera/
│     ├── photo1.jpg
│     └── photo3.jpg
└── test3/
  └── photos/
      └── photo4.jpg
```


The images used are from [Pexels](https://www.pexels.com/), under a free license, and are included for demonstration purposes only:

- [Photo by Francesco Ungaro on Pexels](https://www.pexels.com/photo/hot-air-balloon-2325447/)  
- [Photo by Philippe Donn on Pexels](https://www.pexels.com/photo/brown-hummingbird-selective-focus-photography-1133957/)  
- [Photo by Pixabay on Pexels](https://www.pexels.com/photo/green-leafed-tree-beside-body-of-water-during-daytime-158063/)  
- [Photo by Nathan Cowley on Pexels](https://www.pexels.com/photo/pink-flowers-photography-1128797/)  

---


### ▶️ Example 1: Renaming generic photos

Run the script from the project root:

```bash
./merge_dirs.sh -c -d -o sandbox/my_merge sandbox/test1/ sandbox/test2/ sandbox/test3/
```

Result:

```
sandbox/
└── my_merge/
  ├── .hiddenDir/
  │ └── img.jpg
  ├── DCIM/
  │ └── Camera/
  │   ├── photo1.jpg
  │   ├── photo2.jpg
  │   └── photo3.jpg
  └── photos/
      └── photo4.jpg
```

## Behavior

### Duplicate files

If the same file (same relative path) exists in multiple backups, the script:
- Keeps the **first file** found
- Ignores duplicate copies
- Counts duplicates in the statistics

**Example:**
```
Backup1/photos/beach.jpg  ← This one is kept
Backup2/photos/beach.jpg  ← This one is ignored
```

### Hidden files

Files that start with a period (`.`) are included in the merge:
```
.nomedia
.hidden_file
```

### Automatic cleanup

When using **move** mode, empty directories remaining in the original backups are automatically deleted.

## Script output

### Normal output

```
ℹ️  Destination directory created: merge
ℹ️  Starting merge of 3 directories...
ℹ️  Operation: copy
ℹ️  Processing: Backup1
ℹ️  Processing: Backup2
ℹ️  Processing: Backup3

═════════════════════════════════ ══════
          MERGE SUMMARY
════════════════════════ ═══════════════
Operation:           copy
Destination:             merge
Directories:         3
Files moved:    156
Duplicates skipped: 23
Total processed:    156
═════════════════════════════════ ══════
ℹ️  ✅ Merge completed successfully
```

### Debug mode output (-d)

Displays additional information about each processed file, relative paths, and detailed operations.

## Validations

The script automatically validates:
- ✅ Existence of source directories
- ✅ Read permissions on source
- ✅ That the destination does not already exist
- ✅ At least one input directory


## Warnings

⚠️ **The destination must NOT already exist.** The script will stop if it detects a directory with the same name to prevent accidental overwriting.

⚠️ **In move mode, files are deleted from the original backups. Use `-c` if you want to keep them.

## Troubleshooting

### Error: “The destination already exists”

Delete or rename the destination directory, or use `-o` to specify another name.

### Error: “You do not have read permissions”

Check the permissions of the backup directories:
```bash
ls -la Backup1/
```

### Files are not being moved

Check that you have write permissions in the current directory and that the source directories have read and write permissions.

## Contribute

Contributions are welcome. Please:

1. Fork the repository
2. Create a branch for your feature (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am ‘Add new functionality’`)
4. Push to the branch (`git push origin feature/new-functionality`)
5. Open a Pull Request

## License

MIT License - Feel free to use and modify this script.

## Author

Created to facilitate the consolidation of multiple backups with a common directory structure.

---

**Did you find this script useful?** ⭐ Give the repository a star