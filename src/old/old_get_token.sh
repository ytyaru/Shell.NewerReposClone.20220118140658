GetToken() {
	[ ! -f "$TOKEN_TSV" ] && { Error "TSVファイルが存在しません。ユーザ名、トークン、NOTEの3列をもったTSVファイルを以下パスに作成してください。トークンはGitHubのSettingページで作成してください。\n$TOKEN_TSV"; return; }
	# ユーザ名だけで1件に絞り込めたらそれを返す
	local TEXT_1="$(cat "$TOKEN_TSV" | grep "$USER")"
	local LINE_NUM="$(echo -e "$TEXT_1" | grep -v '^\s*$' | wc -l)"
	local NOTE=${2:-repo}
	[ $LINE_NUM -eq 0 ] && { Error "TSVファイルに指定したユーザ名 $USER のトークンが1件もありません。"; echo ''; return; }
	[ $LINE_NUM -eq 1 ] && { echo -e "$TEXT_1" | cut -f2; return; }
	# ユーザ名とNOTEで1件に絞り込めたらそれを返す
	local NOTE=${2:-private}
	local TEXT_2="$(echo -e "$TEXT_1" |  grep $NOTE | cut -f2;)"
	local LINE_NUM="$(echo -e "$TEXT_2" | grep -v '^\s*$' | wc -l)"
	[ $LINE_NUM -eq 1 ] && { echo -e "$TEXT_2" | cut -f2; return; }
	# ユーザ名とNOTEで絞ると0件になる、または2件以上あるならユーザ名だけで絞ったときに得たリストの中から先頭の1件を返す
	local TEXT_3="$(echo -e "$TEXT_1" | head -n 1 | cut -f2)";
	local LINE_NUM="$(echo -e "$TEXT_3" | grep -v '^\s*$' | wc -l)"
	[ $LINE_NUM -eq 1 ] && { echo -e "$TEXT_3" | cut -f2; return; }
	echo ''
}
