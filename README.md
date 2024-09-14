■サービス概要
ユーザーが鑑賞したコンサートの記録を簡単に残すことができるアプリです。
このライブ行ったはず（記憶を呼び起こすキーとして）、ここでこういう演出があった（自分が興奮したポイントの記録として）、この回だけのゲストがいた（記録に残りにくい情報のストックとして）
行った直後でないと記録に残せない記憶を、より手軽に残して、さらに自分の行ったライブが他の人の目にはどう見えていたのかがわかり、同じアーティストが好きな人同士でフォローする機能など、次のライブに行くのが楽しみになる仕組みをもたせます。

■ このサービスへの思い・作りたい理由
加齢に伴い、直近のコンサートから記憶が消えていくようになりました。私に限らず、ファン同士で話をしていても、「なんだっけ、あのコンサートでさ・・・」みたいな話が増えてきています。
一方で、このようなときに見返すことのできるコンサートレポートを自身のブログに書いている人も、熱心なファンの中に一定数いますが、書くのがとても大変であるとこぼしていました。
多くのファンはSNSを利用しているため、自身のタイムラインへのツイート（ポスト）や、ストーリーへの投稿などに感想を書く人もいますが、いずれも情報としてはフローのため、ストックできません。（見返すことが難しい）
この問題を解決するため、簡単に記録できて共有できるコンサートレポートの書けるアプリを開発いたします。
コンサート全体に対して一言でもいいし、1曲について長く語ってもいい、そんなアプリです。

■ ユーザー層について
ターゲットはコンサート・ライブ・フェスに行く人全員。

■サービスの利用イメージ
スマホからでも簡単にアクセスができて、ライブの帰り道に、ふと投稿できるような、そんな手軽で身近なアプリです。
ユーザーにとってのメリットは大きく３つ。
１つ目は、自分の記憶を預ける場所として活用できること。見返り、振り返りが容易になります。
２つ目は、他人の投稿を見られること。自分の行ったライブを他の人がどう見たのかを読むことで、別視点の楽しさと発見が味わえます。また、気になっていたアーティストのライブの様子を知ることができて、ライブへの行動動機になるほか、過去のライブ情報を予習することも可能です。
3つ目は、ユーザー同士の交流が計れること。同じアーティストが好きなユーザーをフォローすることが可能なので、次のライブがより楽しみになります。

■ ユーザーの獲得について
自身のSNSでの宣伝

■ サービスの差別化ポイント・推しポイント
◯各種プラットフォームとの比較
    ・SNSと比べた優位性
    SNSの発信はフローで流れていってしまうためストックできないデメリットがある
    ・ブログと比べた優位性
    ブログの作成はフォーマットづくり、曲名の入力など、感想を書くまでに面倒なステップが多い
◯類似アプリとの比較
    ＜比較対象＞
    ・Livelog (https://apps.apple.com/jp/app/livelog-%E3%83%A9%E3%82%A4%E3%83%96%E6%83%85%E5%A0%B1%E3%82%92%E3%83%A1%E3%83%A2%E3%81%97%E3%81%A6%E7%B0%A1%E5%8D%98%E3%82%B9%E3%82%B1%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E7%AE%A1%E7%90%86/id1330442649)
    ・LiveFans(https://apps.apple.com/jp/app/livefans/id480524076)

            本アプリ(現時点予定) Livelog     LiveFans
    曲入力      ◎               X          ◯(メドレー入力は良い)
    公演入力    ◯               X           ◯
    シェア      ◯               X           ◯
    振り返り    ◯               △           ◯
    曲試聴      △（将来Spotify） X          ◯（ミュージックと連携）
    検索        △（サイト内のみ）  X          ◯（外部メディア連携されてる）

LiveFansを研究し、良いところ、手軽に取り入れられそうなところは参照する。
主に以下
・曲のメドレー入力
・曲の試聴
・アーティスト、公演検索として外部メディアとの連携（ただ、LiveFansではアーティスト名、曲名等のキーとしては使用されていないので、目的を確認する必要あり）

◯推しポイント
簡単に曲が選べる、ストックできる、SNS共有もできる。

■ 機能候補
MVP
    ユーザー作成
    マイページ
    レポート作成機能
        SpotifyAPI連携
    レポート閲覧機能
        ログイン前トップページ
        ログイン後トップページ
        レポートshowページ
    about usページ
本リリース
    プロフィール編集
    レポート作成機能
        写真アップロード
    レポート閲覧機能
        検索
        いいね機能
        ユーザーフォロー機能
劣後
    レポート作成機能
        ブロック順入れ替え
        新規ブロック作成
        デザインカスタマイズ
    レポート閲覧機能
        検索
            アーティスト検索
            ユーザー検索
            曲検索
    外部メディア検索
        検索
            アーティスト名検索、公演名検索
            メディアによるレポートの閲覧
    楽曲試聴機能


■ 機能の実装方針予定
Rails 7
PostgreSQL
TypeScript
Spotify API
Heroku


### 画面遷移図
Figma：https://www.figma.com/design/DGQjucFmLZqTFq7et0VG86/%E3%82%B3%E3%83%B3%E3%82%B5%E3%83%BC%E3%83%88%E3%83%AC%E3%83%9D%E3%83%BC%E3%83%88app?node-id=0-1&t=welK7QJ7RGN6ZIOa-1

### READMEに記載した機能
MVP
- [x] ユーザー作成(新規登録画面)
- [x] マイページ
- [x] レポート作成機能
- [x] SpotifyAPI連携
- [x] レポート閲覧機能
- [x] ログイン前トップページ
- [x] ログイン後トップページ
- [x] レポートshowページ
- [x] about usページ
本リリース
- [x] プロフィール編集
- [x] 写真アップロード
- [x] 検索
- [x] いいね(レポートごと、ユーザーフォロー)

### 未ログインでも閲覧または利用できるページ
以下の項目は適切に未ログインでも閲覧または利用できる画面遷移になっているか？
- [x] ユーザー作成(新規登録画面)
- [x] レポート閲覧機能
- [x] ログイン前トップページ
- [x] レポートshowページ
- [x] about usページ

### メールアドレス・パスワード変更確認項目
直接変更できるものではなく、一旦メールなどを介して専用のページで変更する画面遷移になっているか？
- [x] メールアドレス
- [x] パスワード

### 各画面の作り込み
画面遷移だけでなく、必要なボタンやフォームが確認できるくらい作り米ているか？
- [x] 作り込みはある程度完了している（Figmaを見て画面の作成ができる状態にある）

## ER図
リンク：https://drive.google.com/file/d/1lDEMBRL2vaehIPKMTzagcGXajJfaFE6w/view?usp=sharing

ユーザーテーブル[Users]
name: ユーザー名
email: 登録メールアドレス
password_hash: パスワード
x_account: X(Twitter)アカウント(@以下)
profile: 自己紹介文
profile_image: ユーザーアイコン

ユーザーフォローテーブル[User_favorits]
user_id
favorit_user_id

コンサートテーブル[Concerts]
concert_name: コンサート名（イベント名）
concert_date: 開演日時
concert_artist: アーティスト名

レポートテーブル[Reports]
user_id
concert_id
is_spoiler: ネタバレ設定（デフォルトFalse←公開）
spoiler_until: ネタバレ期間設定
report_status: 公開設定（公開・非公開・下書き）

レポートイイネテーブル[Report_favorits]
user_id
report_id
favorit_report_id

レポート本文テーブル[Report_bodies]
report_id
report_body: コンサート全体感想
※将来的にカスタマイズで複数項目になる可能性があるためテーブルを分ける

セクション区切り設定[Sections]
report_id
section_name: 区切り名
sectoin_order: 区切り位置

曲テーブル[Songs]
song_name: 曲名
song_artist: アーティスト名
spotify_track_id: Spotify曲ID
spotify_url: SpotifyURL

セットリストテーブル[Set_list_orders]
section_id
song_id
song_order: 曲順
song_impression: 曲感想