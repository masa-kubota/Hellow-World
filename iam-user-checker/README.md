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
$ status reports file NOT found.　
      ↑認証情報レポートが配置されていない場合のメッセージ
　
$ Role list　file NOT found. 
      ↑Role List.csvが配置されていない場合のメッセージ
 ```

2. 処理完了後、シェルスクリプトと同じディレクトリに以下の形式でcsvファイルが出力される
   
   ```
 status_reportsYYYYmmddHHMM
   ```

####  SwitchRole先サーバのIAMユーザ情報を取得する場合　
本シェルスクリプトは踏み台のIAMユーザアカウント情報取得用のツールであるが、以下手順を実施することでSwitchRole先のサーバからも情報を取得することが可能である

1. SwitchRole先のIAMコンソールより、認証情報レポートをダウンロードし、シェルスクリプトとRole_list.csv、と同じフォルダに配置する

2. シェルスクリプトと認証情報レポートを同じディレクトリに配置し実行

   ```
   $ ./iam-user-checker.sh <S3バケット名> -?profaile ＜プロファイル名＞ 
   ```
|項目名|詳細|
|:----|:-|
|S3バケット名|SwitchRole先サーバのs3に作成されたCloudTrailのログが保存刺されているバケット名|
|プロファイル名|credentialsファイルに設定されたSwitchRole先サーバのプロファイル名|

####  SwitchRole先サーバが追加された場合
SwitchRole先のサーバが追加された場合、「Role_list.csv」の末尾に、以下の内容を追記する

   ```
   　*　-e s/<SwitchRole先のアカウントID>/<SwitchRole先のアカウントID>_<環境名>/g
   　*　例：-e s/1234567890/1234567890_kankyou-dev/g　 
   ```

## 出力ファイル情報
#### csvファイル出力される列の詳細

|列情報|詳細|
|:-|:-|
|user|IAMユーザアカウント名|
|password_last_used|AWS マネジメントコンソールに最後にサインインした日付と時刻|
|access_key_1_active|アクセスキーを所有しステータスが Active の場合はTRUE、それ以外の場合はFALSE|
|access_key_1_last_used_date| アクセスキーが最も最近使用された日付と時刻|
|access_key_2_active| ２つ目のアクセスキーを所有しステータスが Active の場合は TRUE、>それ以外の場合はFALSE|
|access_key_2_last_used_date| ２つ目のアクセスキーが最も最近使用された日付と時刻|
|eventTime| 踏み台からSwitchRole先にアクセスした日付と時刻|
|SwitchRole| SwitchRole先と接続ユーザ情報（SwitchRole先:接続ユーザ)|
