#!/usr/bin/env bash

function remove_diff_range {
  sed 's/:[0-9][0-9]*-[0-9][0-9]*$//' | sort | uniq
}

function lint_php_files {
	PROJECT_ROOT="$(git rev-parse --show-toplevel)"
	TEMP_DIRECTORY=$(mktemp -d 2>/dev/null || mktemp -d -t 'dev-lib')

	DIFF_BASE=${DIFF_BASE:-origin/master}
	DIFF_HEAD=${DIFF_HEAD:-$(git rev-parse HEAD)}
	DIFF_ARGS="$DIFF_BASE...$DIFF_HEAD"

	git diff --diff-filter=AM --no-prefix --unified=0 "$DIFF_ARGS" | \
		php /parse-diff-ranges.php | \
		{ grep -E '\.php(:|$)' || true; } > "$TEMP_DIRECTORY/paths-scope-php"

	WPCS_DIR=${WPCS_DIR:-/tmp/wpcs}
	WPCS_GITHUB_SRC=${WPCS_GITHUB_SRC:-WordPress-Coding-Standards/WordPress-Coding-Standards}
	WPCS_GIT_TREE=${WPCS_GIT_TREE:-1.2.1}
	WPCS_STANDARD=${WPCS_STANDARD:-WordPress-Core}
	WordPressVIPMinimum=${WordPressVIPMinimum:-/tmp/VIP}

	git clone -b "$WPCS_GIT_TREE" "https://github.com/$WPCS_GITHUB_SRC.git" "$WPCS_DIR" > /dev/null 2>&1
	git clone -b master "https://github.com/Automattic/VIP-Coding-Standards.git" "$WordPressVIPMinimum"
	ln -s ${WordPressVIPMinimum}/WordPressVIPMinimum ${WPCS_DIR}/WordPressVIPMinimum
	ln -s ${WordPressVIPMinimum}/WordPress-VIP-Go ${WPCS_DIR}/WordPress-VIP-Go
	pushd "$WPCS_DIR" > /dev/null 2>&1
	git clone https://github.com/wimg/PHPCompatibility /tmp/phpcompat > /dev/null 2>&1
	ln -s /tmp/phpcompat/PHPCompatibility PHPCompatibility
	popd > /dev/null 2>&1

	phpcs --config-set installed_paths "$WPCS_DIR"
	phpcs -i
	if ! [[ $(cat "$TEMP_DIRECTORY/paths-scope-php") ]]; then
		echo "No files to process"
		return 0
	fi
	if ! cat "$TEMP_DIRECTORY/paths-scope-php" | remove_diff_range | xargs phpcs -s --report-emacs="$TEMP_DIRECTORY/phpcs-report" --standard="phpcs.xml"; then
		if [ ! -s "$TEMP_DIRECTORY/phpcs-report" ]; then
			return 1
		else
			cat "$TEMP_DIRECTORY/phpcs-report" | php /filter-report-for-patch-ranges.php "$TEMP_DIRECTORY/paths-scope-php" | cut -c$( expr ${#PROJECT_ROOT} + 2 )-
			phpcs_status="${PIPESTATUS[1]}"
			if [[ $phpcs_status != 0 ]]; then
				return $phpcs_status
			fi
		fi
	fi
	rm -rf $TEMP_DIRECTORY

}

lint_php_files
