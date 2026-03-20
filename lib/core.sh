#!/usr/bin/env bash
# =============================================================================
# core.sh — The main creation engine
# Handles: single file creation, batch creation, dry-run mode.
# All flag state is passed in as arguments — core.sh reads no globals
# except the config values set in constants.sh and loaded by utils.sh.
# =============================================================================

# -----------------------------------------------------------------------------
# create_single_file
# Creates one file from a template.
# $1 = filename
# $2 = force flag (true/false)
# $3 = backup flag (true/false)
# $4 = dry_run flag (true/false)
# $5 = description string
# Returns 0 on success, non-zero on failure.
# -----------------------------------------------------------------------------
create_single_file() {
    local filename="$1"
    local force="${2:-false}"
    local backup="${3:-false}"
    local dry_run="${4:-false}"
    local description="${5:-}"

    # -- Validate input -------------------------------------------------------
    if [[ -z "${filename}" ]]; then
        log_error "No filename provided."
        return "${EXIT_USAGE}"
    fi

    # Reject path traversal — filename should be just a name, not a path
    if [[ "${filename}" == */* ]]; then
        log_error "Filename should not contain directory separators: ${filename}"
        log_step  "Use: nsf myfile.py  (not: nsf path/to/myfile.py)"
        return "${EXIT_USAGE}"
    fi

    # -- Resolve extension and template ---------------------------------------
    local ext
    ext=$(get_extension "${filename}")

    if [[ -z "${ext}" ]]; then
        log_error "No file extension detected: ${filename}"
        log_step  "nsf needs an extension to pick the right template (e.g. nsf myscript.py)"
        return "${EXIT_USAGE}"
    fi

    if ! is_supported_extension "${ext}"; then
        log_error "Unsupported extension: .${ext}"
        log_step  "Run 'nsf --list' to see all supported types."
        log_step  "To use a custom template, add ${ext}.tmpl to ~/.config/nsf/templates/"
        return "${EXIT_NO_TEMPLATE}"
    fi

    log_step "Using .${ext} template (${NSF_SUPPORTED_EXTENSIONS[${ext}]})"

    # -- Load and resolve template content ------------------------------------
    local content
    content=$(load_template_content "${ext}" "${filename}" "${description}") || {
        log_error "Failed to load template for .${ext}"
        return "${EXIT_NO_TEMPLATE}"
    }

    # -- Dry-run: show resolved output without writing anything ---------------
    if [[ "${dry_run}" == "true" ]]; then
        local filepath
        filepath="$(pwd)/${filename}"
        echo "${CLR_BOLD}Dry run — nothing will be created${CLR_RESET}"
        echo ""
        printf "  %-14s %s\n" "Would create:" "${filepath}"
        printf "  %-14s %s\n" "Language:"     "${NSF_SUPPORTED_EXTENSIONS[${ext}]}"
        printf "  %-14s %s\n" "Author:"       "${NSF_AUTHOR}"
        printf "  %-14s %s\n" "Date:"         "$(date +"${NSF_DATE_FORMAT}")"
        [[ -n "${description}" ]] && printf "  %-14s %s\n" "Description:" "${description}"
        echo ""
        echo "${CLR_BLUE}$(printf '─%.0s' {1..56})${CLR_RESET}"
        echo "${CLR_BOLD}Resolved content:${CLR_RESET}"
        echo "${CLR_BLUE}$(printf '─%.0s' {1..56})${CLR_RESET}"
        echo "${content}"
        echo "${CLR_BLUE}$(printf '─%.0s' {1..56})${CLR_RESET}"
        echo ""
        echo "${CLR_YELLOW}Post-creation actions that would run:${CLR_RESET}"
        [[ "${DEFAULT_MAKE_EXECUTABLE}" == "true" ]] && \
            printf "  %-20s %s\n" "chmod +x:" "${filename} (if script language)"
        [[ "${ENABLE_GIT_INTEGRATION}" == "true" ]] && \
            printf "  %-20s %s\n" "git add:" "${filename} (if inside a repo)"
        [[ "${ENABLE_EDITOR_SELECTION}" == "true" ]] && \
            printf "  %-20s %s\n" "editor prompt:" "would ask to open file"
        echo ""
        return "${EXIT_OK}"
    fi

    # -- Handle existing file -------------------------------------------------
    local filepath="$(pwd)/${filename}"
    if [[ -f "${filename}" ]]; then
        handle_existing_file "${filename}" "${force}" "${backup}" || return $?
    fi

    # -- Write the file -------------------------------------------------------
    if ! echo "${content}" > "${filename}"; then
        log_error "Failed to write file: ${filename}"
        return "${EXIT_ERR}"
    fi

    # -- Post-creation actions ------------------------------------------------
    [[ "${DEFAULT_MAKE_EXECUTABLE}" == "true" ]] && make_executable "${filename}" "${ext}"
    [[ "${ENABLE_GIT_INTEGRATION}" == "true" ]]  && git_add_file "${filename}"

    # -- Report success -------------------------------------------------------
    local author date
    author="${NSF_AUTHOR}"
    date=$(date +"${NSF_DATE_FORMAT}")
    log_success_box "${filepath}" "${NSF_SUPPORTED_EXTENSIONS[${ext}]}" "${author}" "${date}"

    # -- Offer to open in editor ----------------------------------------------
    [[ "${ENABLE_EDITOR_SELECTION}" == "true" ]] && prompt_editor "${filename}"

    return "${EXIT_OK}"
}

# -----------------------------------------------------------------------------
# create_batch
# Runs create_single_file for each filename in the arguments.
# Tracks per-file results and prints a summary at the end.
# Each file is independent — one failure doesn't stop the others.
# $1-$N = filenames (all remaining arguments)
# Flags are read from the global variables set by argument parsing in bin/nsf
# -----------------------------------------------------------------------------
create_batch() {
    local -a filenames=("$@")
    local -a results=()
    local file

    log_step "Batch mode: ${#filenames[@]} files"
    log_blank

    for file in "${filenames[@]}"; do
        log_step "Processing ${file}..."
        # The `|| true` prevents set -e from halting the loop when one file
        # fails or is skipped (non-zero exit). We capture the real code via $?
        ENABLE_EDITOR_SELECTION="false" \
        create_single_file \
            "${file}" \
            "${NSF_FLAG_FORCE}" \
            "${NSF_FLAG_BACKUP}" \
            "${NSF_FLAG_DRY_RUN}" \
            "${NSF_FLAG_DESC}" || true
        local exit_code=$?

        case "${exit_code}" in
            "${EXIT_OK}")       results+=("${file}:ok") ;;
            "${EXIT_EXISTS}")   results+=("${file}:skip") ;;
            *)                  results+=("${file}:fail") ;;
        esac

        log_blank
    done

    log_batch_summary "${results[@]}"
}
