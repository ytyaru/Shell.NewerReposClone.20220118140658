#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# 最後にpushしたリポジトリをクローンする。
# CreatedAt: 2022-01-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	local INIT_USER=ytyaru
	local INIT_NUM=1
	local USER="$INIT_USER"
	local NUM="$INIT_NUM"
	local TOKEN_TSV=/home/pi/root/work/record/pc/account/github/tokens.tsv
	PATH_CLONE="$(pwd)"
	cd "$HERE"
	[ -f 'error.sh' ] && . error.sh
#	[ -f 'get_tokens.sh' && . get_tokens.sh
	ParseCommand() {
		THIS_NAME=`basename "$BASH_SOURCE"`
		SUMMARY='最後にpushしたリポジトリをクローンする。'
		VERSION=0.0.1
		ARG_FLAG=; ARG_OPT=;
		Help() { eval "echo -e \"$(cat help.txt)\""; }
		Version() { echo "$VERSION"; }
		while getopts ":hv:" OPT; do
		case $OPT in
			h) Help; exit 0;;
			v) Version; exit 0;;
		esac
		done
		shift $(($OPTIND - 1))
	}
	ParseCommand "$@"
	IsInt() { test 0 -eq $1 > /dev/null 2>&1 || expr $1 + 0 > /dev/null 2>&1; }
	[ 1 -eq $# ] && { IsInt "$1" && NUM=$1 || USER=$1; }
	[ 2 -eq $# ] && { USER=$1; NUM=$2; }
	IsInt "$NUM" || Error '引数は整数にしてください。';
	[ $NUM -lt 1 ] && Error '取得数は1〜100以内の整数にしてください。'
	[ 100 -lt $NUM ] && Error '取得数は1〜100以内の整数にしてください。'

	NewerReposApiUrl() {
		local TYPE='all'          # all,public,private,forks,sources,member,internal
		local SORT="${2:-pushed}" # created,updated,pushed,full_name
		local DIRECTION=$([ "$SORT" == 'full_name' ] && echo 'asc' || echo 'desc')
		local PER_PAGE=${NUM:-1}
		local PAGE=1
		echo "https://api.github.com/users/$USER/repos?type=$TYPE&sort=$SORT&direction=$DIRECTION&per_page=$PER_PAGE&page=$PAGE"
	}
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
		#cat "$TOKEN_TSV" | grep $USER | grep $NOTE | cut -f2
	}
	ReqNewerRepos() {
		curl -H "Authorization: token $1" "$(NewerReposApiUrl $USER)"
	}
	NewerRepoUrls() { echo "$(ReqNewerRepos "$1")" | jq -r .[].clone_url; }

	# なぜか空文字のとき終了できない
	echo "$USER"
	echo "$NUM"
	echo "$(NewerReposApiUrl)"
	local TOKEN="$(GetToken $USER | sed -e "s/[\r\n]\+//g")"
#	echo "TOKEN: $TOKEN"
	[ -z "$TOKEN" ] && return 1 || :;

	# ディレクトリ既存エラー（already exists and is not an empty directory.）で中断せず全件実行するようにsetする
	set +e
	cd "$PATH_CLONE"
	echo -e "$(NewerRepoUrls "$TOKEN")" | while read url; do
		echo $url
		git clone "$url"
	done
	set -e
}
Run "$@"

