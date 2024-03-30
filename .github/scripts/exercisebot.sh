#!/bin/bash
set -e

add_args=""
commit_args=""
push_args=""

if ! test -f "scripts.js"; then
  echo "Completing step 1"
  cat .github/include/vaihe1.js > scripts.js
  add_args=("scripts.js")
  commit_args=("-m" "Kellotoiminnallisuus toteutettu" "-m" "Liitä nappulaan näin: <button onclick=\"setTime()\">Mitä kello on?</button>")
  push_args=("origin" "develop")
elif ! grep -q "#datetime" styles.css; then
  if grep -q "setTime()" index.html; then
    echo "Completing step 2"
    cat .github/include/vaihe3.css >>styles.css
    add_args=("styles.css")
    commit_args=("-m" "Tyylitelty kellonaikaelementti")
    push_args=("origin" "develop")
  else
    echo "Step 2 prerequisited incomplete, no action"
    exit 0
  fi
elif ! grep -q "setInterval" scripts.js; then
  echo "Completing step 3"
  cat .github/include/vaihe2.js >> scripts.js
  add_args=("scripts.js")
  commit_args=("-m" "Kellon automaattinen päivitys toteutettu")
  push_args=("origin" "develop")
elif ! grep -q "canvas" scripts.js; then
  echo "Completing step 4"
  cat .github/include/vaihe4.js > scripts.js
  cat .github/include/vaihe4.css >> styles.css
  add_args=("scripts.js" "styles.css")
  commit_args=("-m" "Analoginen kello toteutettu, taustatyyli viimeistelty")
  push_args=("origin" "develop")
else
  echo "Steps complete, no action needed"
  exit 0
fi

if [[ "$1" == "-c" ]]; then
  echo "Committing changes"
  git add ${add_args[@]}
  git commit "${commit_args[@]}"
  git push ${push_args[@]}
else
  echo "Testing, commands to be given:"
  echo "add" "${add_args[@]}"
  echo "commit" "${commit_args[@]}"
  echo "push" "${push_args[@]}"
fi
