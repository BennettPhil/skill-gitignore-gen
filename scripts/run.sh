#!/usr/bin/env bash
set -euo pipefail

# gitignore-gen: Generate language-specific .gitignore files
# Usage: run.sh [--help] [--list] <template> [template...]

get_patterns() {
    local lang="$1"
    case "$lang" in
        python)
            cat << 'EOF'
__pycache__/
*.pyc
*.pyo
*.egg
*.egg-info/
.eggs/
dist/
build/
.venv/
venv/
env/
.env
*.whl
.mypy_cache/
.pytest_cache/
htmlcov/
.coverage
.tox/
.nox/
*.so
EOF
            ;;
        node|javascript|typescript)
            cat << 'EOF'
node_modules/
dist/
build/
.env
.env.local
.env.*.local
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
coverage/
.nyc_output/
.cache/
*.tsbuildinfo
EOF
            ;;
        java)
            cat << 'EOF'
*.class
*.jar
*.war
*.ear
target/
.gradle/
build/
.settings/
.project
.classpath
*.iml
.idea/
out/
hs_err_pid*
EOF
            ;;
        go)
            cat << 'EOF'
/vendor/
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
go.work
EOF
            ;;
        rust)
            cat << 'EOF'
/target/
Cargo.lock
**/*.rs.bk
*.pdb
EOF
            ;;
        ruby)
            cat << 'EOF'
*.gem
*.rbc
.bundle/
vendor/bundle
.config
coverage/
pkg/
spec/reports/
tmp/
.byebug_history
.ruby-version
.ruby-gemset
Gemfile.lock
EOF
            ;;
        swift)
            cat << 'EOF'
.build/
Packages/
xcuserdata/
*.xcodeproj/project.xcworkspace/
*.xcodeproj/xcuserdata/
DerivedData/
.swiftpm/
Package.resolved
*.playground/timeline.xctimeline
*.playground/playground.xcworkspace
EOF
            ;;
        kotlin)
            cat << 'EOF'
*.class
*.jar
*.war
target/
.gradle/
build/
.idea/
*.iml
out/
.kotlin/
EOF
            ;;
        c|cpp)
            cat << 'EOF'
*.o
*.obj
*.so
*.dylib
*.dll
*.a
*.lib
*.exe
*.out
*.d
build/
cmake-build-*/
CMakeFiles/
CMakeCache.txt
Makefile
*.gch
*.pch
EOF
            ;;
        csharp)
            cat << 'EOF'
bin/
obj/
*.suo
*.user
*.userosscache
*.sln.docstates
[Dd]ebug/
[Rr]elease/
x64/
x86/
*.nupkg
.nuget/
packages/
*.vs/
EOF
            ;;
        dart)
            cat << 'EOF'
.dart_tool/
.packages
build/
pubspec.lock
*.iml
.idea/
.flutter-plugins
.flutter-plugins-dependencies
EOF
            ;;
        elixir)
            cat << 'EOF'
/_build/
/cover/
/deps/
/doc/
erl_crash.dump
*.ez
*.beam
/config/*.secret.exs
.fetch
EOF
            ;;
        macos)
            cat << 'EOF'
.DS_Store
.AppleDouble
.LSOverride
._*
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
.AppleDB
.AppleDesktop
EOF
            ;;
        linux)
            cat << 'EOF'
*~
.fuse_hidden*
.directory
.Trash-*
.nfs*
EOF
            ;;
        windows)
            cat << 'EOF'
Thumbs.db
Thumbs.db:encryptable
ehthumbs.db
ehthumbs_vista.db
*.stackdump
[Dd]esktop.ini
$RECYCLE.BIN/
*.lnk
EOF
            ;;
        vim)
            cat << 'EOF'
[._]*.s[a-v][a-z]
!*.svg
[._]*.sw[a-p]
[._]s[a-rt-v][a-z]
[._]ss[a-gi-z]
[._]sw[a-p]
Session.vim
Sessionx.vim
.netrwhist
*~
tags
EOF
            ;;
        vscode)
            cat << 'EOF'
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
*.code-workspace
.history/
EOF
            ;;
        jetbrains)
            cat << 'EOF'
.idea/
*.iml
*.iws
*.ipr
out/
cmake-build-*/
.idea_modules/
atlassian-ide-plugin.xml
EOF
            ;;
        emacs)
            cat << 'EOF'
*~
\#*\#
/.emacs.desktop
/.emacs.desktop.lock
*.elc
auto-save-list
tramp
.\#*
flycheck_*.el
.projectile
.dir-locals.el
EOF
            ;;
        *)
            return 1
            ;;
    esac
}

TEMPLATES=(
    c cpp csharp dart elixir emacs go java jetbrains javascript
    kotlin linux macos node python ruby rust swift typescript vim
    vscode windows
)

show_help() {
    cat << 'EOF'
Usage: run.sh [OPTIONS] <template> [template...]

Generate language-specific .gitignore files.

Arguments:
  template    One or more template names (e.g., python, node, macos)

Options:
  --help      Show this help message
  --list      Show all available template names

Examples:
  run.sh python                     # Single language
  run.sh python node macos vscode   # Combined templates
  run.sh --list                     # List all templates
  run.sh go linux vim > .gitignore  # Save to file
EOF
}

show_list() {
    echo "Available templates:"
    local count=0
    local line="  "
    for t in "${TEMPLATES[@]}"; do
        line+=$(printf "%-12s" "$t")
        count=$((count + 1))
        if (( count % 5 == 0 )); then
            echo "$line"
            line="  "
        fi
    done
    if [[ -n "${line// /}" ]]; then
        echo "$line"
    fi
}

# --- Main ---

if [[ $# -eq 0 ]]; then
    echo "Error: no template specified. Use --help for usage." >&2
    exit 1
fi

if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [[ "$1" == "--list" ]]; then
    show_list
    exit 0
fi

# Validate all arguments first
for arg in "$@"; do
    if ! get_patterns "$arg" > /dev/null 2>&1; then
        echo "Error: unknown template '$arg'" >&2
        echo "Use --list to see available templates." >&2
        exit 1
    fi
done

# Collect all patterns
all_patterns=""
for arg in "$@"; do
    patterns=$(get_patterns "$arg")
    all_patterns+="$patterns"$'\n'
done

# Header
echo "# Generated by gitignore-gen"
echo "# Templates: $*"
echo ""

# Deduplicate, remove blank lines, sort
echo "$all_patterns" | grep -v '^$' | sort -u
