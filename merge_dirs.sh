#!/usr/bin/env bash

# Script para hacer merge de múltiples directorios de backup
# Uso: ./merge_dirs.sh [-c] [-d destino] directorio1 directorio2 [directorio3 ...]

set -euo pipefail

# Variables globales
readonly SCRIPT_NAME=$(basename "$0")
DEBUG=false
operation="copy"
force_destination=false
destination="merge"
declare -a source_dirs=()
#declare -A processed_files
processed_files_log=$(mktemp)
#trap 'rm -f "${processed_files_log}"' EXIT
files_copied=0
files_moved=0
files_skipped=0


# Colors for logs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # colorless

# Función para mostrar uso
show_usage() {
    cat << EOF
Uso: ${SCRIPT_NAME} [-c|-m] [-d] [-o destino] directorio1 directorio2 [...]

Opciones:
    -c              Copiar archivos en lugar de moverlos
    -m              Mueve archivos en lugar de copiarlos
    -o destino      Directorio destino (por defecto: merge)
    -d              Mostrar información de depuración
    -f              Fuerza el nombre del directorio destino
    -h              Mostrar esta ayuda

Argumentos:
    directorio1+    Uno o más directorios de backup a fusionar

Ejemplo:
    ${SCRIPT_NAME} Backup1 Backup2 Backup3
    ${SCRIPT_NAME} -c -o MiMerge Backup1 Backup2
    ${SCRIPT_NAME} -m -o MiMerge Backup1 Backup2
EOF
}

# Función para log
log_info()   { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()   { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error()  { echo -e "${RED}[ERROR]${NC} $*"; }
log_debug() {    [[ "$DEBUG" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $*"; true; }

# Función para procesar argumentos
parse_arguments() {
    while getopts ":cmdfo:h" opt; do
        case ${opt} in
            c)
                operation="copy"
                ;;
            m)
                operation="move"
                ;;
            o)
                destination="${OPTARG}"
                ;;
            d)
                DEBUG="true"
                ;;
            f)
                force_destination="true"
                ;;
            h)
                show_usage
                exit 0
                ;;
            \?)
                log_error "Opción inválida: -${OPTARG}. Usa -h para ver la ayuda."
                ;;
            :)
                log_error "La opción -${OPTARG} requiere un argumento."
                ;;
        esac
    done
    shift $((OPTIND - 1))

    # Los argumentos restantes son los directorios fuente
    if [[ $# -lt 1 ]]; then
        log_error "Debes proporcionar al menos un directorio fuente. Usa -h para ver la ayuda."
    fi

    source_dirs=("$@")
}

# Función para validar directorios fuente
validate_sources() {
    local dir
    for dir in "${source_dirs[@]}"; do
        if [[ ! -d "${dir}" ]]; then
            log_error "El directorio '${dir}' no existe o no es un directorio."
        fi
        if [[ ! -r "${dir}" ]]; then
            log_error "No tienes permisos de lectura en '${dir}'."
        fi
    done
}

# Función para crear directorio destino
create_destination() {
    if [[ -e "${destination}" && "${force_destination}" == "false" ]]; then
        log_error "El destino '${destination}' ya existe. Elige otro nombre."
        exit 1
    fi
    
    mkdir -p "${destination}" || log_error "No se pudo crear el directorio destino '${destination}'."
    log_info "Directorio destino creado: ${destination}"
}

# Función para obtener ruta relativa
get_relative_path() {
    local file="$1"
    local base="$2"
    echo "${file#${base}/}"
}

# Función para procesar archivos de un directorio
process_directory() {
    local source_dir="$1"
    local file relative_path dest_file dest_dir
    
    log_info "Procesando: ${source_dir}"
    
    # Buscar todos los archivos incluyendo ocultos
    while IFS= read -r -d '' file; do
        # Obtener ruta relativa
        relative_path=$(get_relative_path "${file}" "${source_dir}")
        dest_file="${destination}/${relative_path}"
        
        log_debug "Procesando: ${relative_path}"

        # Si ya existe, saltar
        if grep -q -x "${relative_path}" "${processed_files_log}"; then
            ((files_skipped++)) || true
            log_debug "Saltando: ${dest_file}"
            continue
        fi
        
        # Crear directorio destino si no existe
        dest_dir=$(dirname "${dest_file}")
        mkdir -p "${dest_dir}"
        
        # Copiar o mover según la operación
        if [[ "${operation}" == "copy" ]]; then
            cp -p "${file}" "${dest_file}"
            ((files_copied++)) || true
        else
            mv "${file}" "${dest_file}"
            ((files_moved++)) || true
        fi
        
        # Marcar como procesado
        echo "${relative_path}" >> "${processed_files_log}"
        
    done < <(find "${source_dir}" -type f -print0)
}

# Función para limpiar directorios vacíos después de mover
cleanup_empty_dirs() {
    if [[ "${operation}" == "move" ]]; then
        local dir
        for dir in "${source_dirs[@]}"; do
            if [[ -d "${dir}" ]]; then
                find "${dir}" -type d -empty -delete 2>/dev/null || true
            fi
        done
    fi
}

# Función para mostrar resumen
show_summary() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "          RESUMEN DEL MERGE"
    echo "═══════════════════════════════════════"
    echo "Operación:         ${operation}"
    echo "Destino:           ${destination}"
    echo "Directorios:       ${#source_dirs[@]}"
    if [[ "${operation}" == "copy" ]]; then
        echo "Archivos copiados: ${files_copied}"
    else
        echo "Archivos movidos:  ${files_moved}"
    fi
    echo "Duplicados saltados: ${files_skipped}"
    echo "Total procesados:  $((files_copied + files_moved))"
    echo "═══════════════════════════════════════"
}

# Función principal
main() {
    parse_arguments "$@"
    validate_sources
    create_destination
    
    log_info "Iniciando merge de ${#source_dirs[@]} directorio(s)..."
    log_info "Operación: ${operation}"
    
    local dir
    for dir in "${source_dirs[@]}"; do
        process_directory "${dir}"
    done
    
    cleanup_empty_dirs
    show_summary
    
    log_info "✅ Merge completado exitosamente"
}

# Ejecutar script
main "$@"