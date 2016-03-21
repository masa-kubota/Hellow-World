# iam-user-checker.sh

* AWS IAMユーザアカウント使用状況確認ツール 

## 機能
AWS IAMユーザアカウント情報の以下の情報をcsvファイルにて出力

* 作成済みのIAMユーザのアカウント情報と最後にサインインした日時
* アクセスキーの有効・無効、最終使用日時
* 踏み台のIAMユーザで、SwitchRoleした各環境への最終アクセス日時

## 前提条件

* jqとAWS CLIがインストールされていること
* credentialsファイルを以下を参照し設定する


      http://lodge.mediba.jp/articles/228

## 準備

#####認証情報レポートのダウンロード
シェルスクリプトを実行する上で必ず必要であるが、作成時点では、AWS CLIより取得することができない為、踏み台サーバのIAMコンソール上から手動にて認証情報レポートを取得する必要がある

1. AWS マネジメントコンソール にサインインし、IAMコンソールを開く
2. ナビゲーションペインで、[認証情報レポート] をクリック
3. [レポートをダウンロード] をクリックし、csvファイルをダウンロード
4. シェルスクリプトと同じディレクトリに配置する

 
    * 認証情報レポートの取得については以下参照

   ```
http://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_credentials_getting-report.html
```

## 使い方

1. シェルスクリプトとRole_list.csv、認証情報レポートを同じディレクトリに配置し実行する
 
   * Role_list.csv、認証情報レポートが配置されていない場合、 以下のメッセージが出力され処理が中止される
    
    ```
$ status file NOT found.　
```

2. 処理完了後、シェルスクリプトと同じディレクトリに以下の形式でcsvファイルが出力される
   
   ```
 status_reportsYYYYmmddHHMM
   ```

####  SwitchRole先サーバのIAMユーザ情報を取得する場合　
本シェルスクリプトは踏み台のIAMユーザアカウント情報取得用のツールであるが、以下手順を実施することでSwitchRole先のサーバからも情報を取得することが可能である

1. SwitchRole先のIAMコンソールより、認証情報レポートをダウンロードし、シェルスクリプトとrole_list.csv、と同じフォルダに配置する

2. シェルスクリプトと認証情報レポートを同じディレクトリに配置、以下のとおり引数を含めて実行する

   ```
   $ ./iam-user-checker.sh <S3バケット名> -?profaile ＜プロファイル名＞ 
　　例：./iam-user-checker.sh CloudTrail_log -?profaile test_prd 
   ```
|項目名|詳細|
|:-------------------------------|:----------------------------------------------|
|S3バケット名|SwitchRole先サーバのs3に作成されたCloudTrailのログが保存刺されているバケット名|
|プロファイル名|credentialsファイルに設定されたSwitchRole先サーバのプロファイル名|

####  SwitchRole先サーバが追加された場合
* SwitchRole先のサーバが追加された場合、「role_list.csv」の末尾に、以下の内容を追記する
    ```
     -e s/<SwitchRole先のアカウントID>/<SwitchRole先のアカウントID>_<環境名>/g
     例：-e s/1234567890/1234567890_kankyou-dev/g　 
    ```

## 出力ファイル情報
#### csvファイル出力される列の詳細

|列情報|詳細|
|:----------------------------|:-------------------------------------------------------------|
|user|IAMユーザアカウント名|
|passwordlastused|AWS マネジメントコンソールに最後にサインインした日付と時刻|
|accesskey1active|アクセスキーを所有しステータスがActive の場合はTRUEそれ以外の場合はFALSE|
|accesskey1lastuseddate|アクセスキーが最も最近使用された日付と時刻|
|accesskey2active|２つ目のアクセスキーを所有しステータスがActiveの場合はTRUEそれ以外の場合はFALSE|
|accesskey2lastuseddate|２つ目のアクセスキーが最も最近使用された日付と時刻|
|eventTime|踏み台からSwitchRole先にアクセスした日付と時刻|
|SwitchRole|SwitchRole先と接続ユーザ情報（SwitchRole先:接続ユーザ)|

| Left align | Right align | Center align |
|:-----------|------------:|:------------:|
| This       |        This |     This     |
| column     |      column |    column    |
| will       |        will |     will     |
| be         |          be |      be      |
| left       |       right |    center    |
| aligned    |     aligned |   aligned    |

