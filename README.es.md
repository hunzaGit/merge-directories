<!-- TOC start (generated with https://github.com/derlin/bitdowntoc) -->

- [Merge Directories](#merge-Directories)
   * [Características](#características)
   * [Instalación](#instalación)
   * [Requisitos](#requisitos)
   * [Uso](#uso)
      + [Sintaxis](#sintaxis)
      + [Opciones](#opciones)
      + [Ejemplos](#ejemplos)
   * [🧪 Ejemplo de uso con el directorio `sandbox`](#-ejemplo-de-uso-con-el-directorio-sandbox)
      + [📁 Estructura del ejemplo](#-estructura-del-ejemplo)
      + [▶️ Ejemplo 1: renombrar fotos genéricas](#%EF%B8%8F-ejemplo-1-renombrar-fotos-genéricas)
   * [Comportamiento](#comportamiento)
      + [Archivos duplicados](#archivos-duplicados)
      + [Archivos ocultos](#archivos-ocultos)
      + [Limpieza automática](#limpieza-automática)
   * [Salida del script](#salida-del-script)
      + [Salida normal](#salida-normal)
      + [Salida en modo debug (-d)](#salida-en-modo-debug-d)
   * [Validaciones](#validaciones)
   * [Advertencias](#advertencias)
   * [Solución de problemas](#solución-de-problemas)
      + [Error: "El destino ya existe"](#error-el-destino-ya-existe)
      + [Error: "No tienes permisos de lectura"](#error-no-tienes-permisos-de-lectura)
      + [Los archivos no se mueven](#los-archivos-no-se-mueven)
   * [Contribuir](#contribuir)
   * [Licencia](#licencia)
   * [Autor](#autor)

<!-- TOC end -->

# Merge Directories

[English](README.md) | Español

Script en Bash para fusionar múltiples directorios en uno solo, ideal para consolidar backups de móviles u otros dispositivos que comparten estructura de directorios.

> 💬 **Nota del autor**  
> Mis conocimientos de Bash son limitados y he intentado mantener el código lo más claro y comprensible posible.  
> Aun así, puede contener errores o partes mejorables.  
> Se agradecen sugerencias y *pull requests* que ayuden a mejorar la claridad o la fiabilidad del script.


## Características

- 🔀 Fusiona múltiples directorios manteniendo la estructura de árbol
- 📦 Mueve o copia archivos según preferencia
- 🔍 Incluye archivos ocultos
- ⚡ Ignora duplicados automáticamente (conserva el primer archivo encontrado)
- 📊 Muestra estadísticas detalladas del proceso
- 🧹 Limpia directorios vacíos tras mover archivos
- 🐛 Modo debug para seguimiento detallado
- ✅ Sin dependencias externas

## Instalación

```bash
# Clonar repo
git clone https://github.com/hunzaGit/merge-directories.git
# o descargar el script
curl -O https://github.com/hunzaGit/merge-directories/main/merge_dirs.sh

# Dar permisos de ejecución
chmod +x merge_dirs.sh
```

## Requisitos

- **Bash** 3.2+ (incluido en macOS por defecto)
- Permisos de lectura en directorios origen
- Permisos de escritura en ubicación destino
- No se admiten caracteres raros como "[", "]". Nombre valido "Backup OP 5T 2020-01-10"

## ⚠️ Compatibilidad probada
### MacOs
Probado en **macOS 14.6.1 (Apple Silicon)** 
Verificado tanto con archivos locales en SSD como con archivos en una unidad de red SMB conectada desde un equipo con **Windows 10** en red local.  

### Linux (Ubuntu, Debian) o CentOS/Fedora
No se ha verificado su funcionamiento en entornos **Linux**, **CentOS** u otros sistemas operativos, por lo que podrían requerirse ajustes adicionales (por ejemplo, rutas, permisos o diferencias en la salida de comandos).


## Uso

### Sintaxis

```bash
./merge_dirs.sh [-c] [-d destino] [-v] directorio1 directorio2 [directorio3 ...]
```

### Opciones

| Opción | Descripción |
|--------|-------------|
| `-c` | Copiar archivos en lugar de moverlos. Por defecto |
| `-c` | Mueve archivos en lugar de copiarlos |
| `-o <destino>` | Especificar directorio destino (default: `merge`) |
| `-d` | Modo debug: muestra logs detallados del proceso |
| `-f` | Fuerza el nombre del directorio destino si ya existe |
| `-h` | Mostrar ayuda |

### Ejemplos

**Caso de uso típico: Fusionar backups de móvil**

```bash
./merge_dirs.sh Backup1 Backup2 Backup3
```

**Estructura antes:**
```
Backup1/
├── DCIM/Camera/foto1.jpg
└── Music/cancion1.mp3

Backup2/
├── DCIM/Camera/foto2.jpg
└── Documents/doc1.pdf

Backup3/
└── DCIM/Screenshots/screen1.png
```

**Estructura después:**
```
resultMerge/
├── DCIM/
│   ├── Camera/
│   │   ├── foto1.jpg
│   │   └── foto2.jpg
│   └── Screenshots/screen1.png
├── Music/cancion1.mp3
└── Documents/doc1.pdf
```

**Copiar en lugar de mover (conservar backups originales):**

```bash
./merge_dirs.sh -c Backup1 Backup2 Backup3
```

**Especificar destino personalizado:**

```bash
./merge_dirs.sh -o BackupUnificado2024 Backup1 Backup2
```

**Modo debug para seguimiento detallado:**

```bash
./merge_dirs.sh -d Backup1 Backup2
```

**Combinar opciones:**

```bash
./merge_dirs.sh -c -d -o MiBackup Backup1 Backup2 Backup3
```


## 🧪 Ejemplo de uso con el directorio `sandbox`

El repositorio incluye un directorio `sandbox/` con ejemplos listos para probar el funcionamiento del script sin necesidad de usar tus propias fotos.

### 📁 Estructura del ejemplo
```
sandbox/
├── test1/
│ ├── .hiddenDir/
│ │ └── img.jpg
│ ├── DCIM/
│   └── Camera/
│     ├── foto1.jpg
│     └── foto2.jpg
├── test2/
│ ├── DCIM/
│   └── Camera/
│     ├── foto1.jpg
│     └── foto3.jpg
└── test3/
  └── photos/
      └── foto4.jpg
```


Las imágenes utilizadas proceden de [Pexels](https://www.pexels.com/), bajo licencia libre, y se incluyen únicamente con fines demostrativos:

- [Foto de Francesco Ungaro en Pexels](https://www.pexels.com/photo/hot-air-balloon-2325447/)  
- [Foto de Philippe Donn en Pexels](https://www.pexels.com/photo/brown-hummingbird-selective-focus-photography-1133957/)  
- [Foto de Pixabay en Pexels](https://www.pexels.com/photo/green-leafed-tree-beside-body-of-water-during-daytime-158063/)  
- [Foto de Nathan Cowley en Pexels](https://www.pexels.com/photo/pink-flowers-photography-1128797/)  

---

### ▶️ Ejemplo 1: renombrar fotos genéricas

Ejecuta el script desde la raíz del proyecto:

```bash
./merge_dirs.sh -c -d -o sandbox/my_merge sandbox/test1/ sandbox/test2/ sandbox/test3/
```

Resultado:

```
sandbox/
└── my_merge/
  ├── .hiddenDir/
  │ └── img.jpg
  ├── DCIM/
  │ └── Camera/
  │   ├── foto1.jpg
  │   ├── foto2.jpg
  │   └── foto3.jpg
  └── photos/
      └── foto4.jpg
```

## Comportamiento

### Archivos duplicados

Si existe el mismo archivo (misma ruta relativa) en múltiples backups, el script:
- Conserva el **primer archivo** encontrado
- Ignora las copias duplicadas
- Cuenta los duplicados en las estadísticas

**Ejemplo:**
```
Backup1/fotos/playa.jpg  ← Se conserva este
Backup2/fotos/playa.jpg  ← Se ignora
```

### Archivos ocultos

Los archivos que comienzan con punto (`.`) se incluyen en el merge:
```
.nomedia
.hidden_file
```

### Limpieza automática

Al usar modo **move**, los directorios vacíos que quedan en los backups originales se eliminan automáticamente.

## Salida del script

### Salida normal

```
ℹ️  Directorio destino creado: merge
ℹ️  Iniciando merge de 3 directorio(s)...
ℹ️  Operación: copy
ℹ️  Procesando: Backup1
ℹ️  Procesando: Backup2
ℹ️  Procesando: Backup3

═══════════════════════════════════════
          RESUMEN DEL MERGE
═══════════════════════════════════════
Operación:           copy
Destino:             merge
Directorios:         3
Archivos movidos:    156
Duplicados saltados: 23
Total procesados:    156
═══════════════════════════════════════
ℹ️  ✅ Merge completado exitosamente
```

### Salida en modo debug (-d)

Muestra información adicional de cada archivo procesado, rutas relativas, y operaciones detalladas.


## Validaciones

El script valida automáticamente:
- ✅ Existencia de directorios origen
- ✅ Permisos de lectura en origen
- ✅ Que el destino no exista previamente
- ✅ Al menos un directorio de entrada

## Advertencias

⚠️ **El destino NO debe existir previamente**. El script se detendrá si detecta un directorio con el mismo nombre para evitar sobrescrituras accidentales.

⚠️ **En modo move**, los archivos se eliminan de los backups originales. Usa `-c` si quieres conservarlos.

## Solución de problemas

### Error: "El destino ya existe"

Elimina o renombra el directorio destino, o usa `-o` para especificar otro nombre.

### Error: "No tienes permisos de lectura"

Verifica los permisos de los directorios backup:
```bash
ls -la Backup1/
```

### Los archivos no se mueven

Verifica que tengas permisos de escritura en el directorio actual y que los directorios origen tengan permisos de lectura y escritura.

## Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Haz fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Añade nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## Licencia

MIT License - Siéntete libre de usar y modificar este script.

## Autor

Creado para facilitar la consolidación de backups múltiples con estructura de directorios común.

---

**¿Encontraste útil este script?** ⭐ Dale una estrella al repositorio