# A-Secure-Person2Person-P2P-Micropayment-System
108-1 NTUIM course: Computer Networks and Applications

## （安全的第三方支付使用者對使用者小額付款系統）
  一套具安全傳輸的簡單網際網路第三方支付使用者對使用者小額付款（ Micropayment） 系統。此系統包含三大功能。 一、 第三方支付Server端對Client端（ 使用者）的統一管理， 包含帳號管理、好友名單管理、認證以及Client帳戶管理等。 二、 Client間即時通訊。 三、 Client與Server以及Client間的通訊，都可以各自加密，加密的鑰匙（ encryption key， 又稱secret key） 由當下通訊的雙方議定。

  本作業的目標是設計與實作一套簡單的好友間轉帳功能。 同學將設計、實作一套安全傳輸的簡單「 安全的第三方支付使用者對使用者小額付款系統」包含Client 與 multithreaded Server端的軟體，以及安全傳輸的軟體撰寫。

1. Client端的兩個主要功能：
- 安全的與第三方支付 Server的通訊
- 一對一安全的Client間對談

2. Multi-threaded server 端的主要功能：
- 接受 client 的安全連結，並根據要求(request)回覆訊息（ reply）

3. 安全通訊的主要功能：
- 每一個Client 與 Server間， 以及Client間的通訊，都必須加密，加密的鑰匙（encryption key,又稱secret key） 由當下通訊的雙方議定。

### 如何編譯
打開 terminal， 依據 OS 在檔案目錄下輸入”make ubuntu” 或” make mac” 執行 makefile

### 執行
1. multi-thread server 端程式：輸入” ./server [port number]執行
2. client： 輸入” ./client 127.0.0.1 [port number]

### 需求環境
Ubuntu 18.04 安裝 openssl

### 功能
1. **註冊**
- Client： 可直接輸入 REGISTER#user_name 或輸入 R 後再輸入 user_name
， 已登入狀態下無法進行新的註冊。
- Server：
成功註冊回傳： 100 OK
已在登入狀態下回傳： please type the right option number!
已註冊過回傳： 210 FAIL

2.**登入**
- Client： 可直接輸入 user_name#port_number 或輸入 L 後再依序輸入
user_name 和 port_number，成功登入後能看到自己帳戶餘額和在線名單
- Server：
成功登入 call function getOnlieList()回傳餘額和在線清單
已在登入狀態下回傳： please type the right option number!
尚未註冊回傳： 220 AUTH_FAIL

3. **列表**
- Client： 登入狀態下輸入 List，列表出最新自己帳戶餘額和在線名單，
未登入下會先要求登入
- Server：
登入下成功列表： call function getOnlieList()回傳餘額和在線清單
未登入下回傳： 220 AUTH_FAIL

4.**登出**
- Client： 登入狀態下輸入 Exit，登出並結束程式，未登入下要求先登入
- Server：
成功登出回傳： Bye!
未登入下回傳： 220 AUTH_FAIL
每次動作 Server 端皆會印出 receive_message(含編號) 和
send_message 以及 Socket 編號， 登入/出會顯示 User xxx log in/out

### 加密資料傳輸邏輯
在 main function 內先用 socket 建連線， 在加上 SSL 連線， 步驟如下：
1. Initial socket
2. Connect socket
3. Initial SSL
<1> SSL_library_init: Initial SSL library
<2> SSL_CTX_new: create a new SSL_CTX object to enable SSL connection
<3> SSL_new: create SSL data stucture
<4> SSL_set_fd: bind ssl and socket fd
<5> SSL_accept: connect to client
引用自： http://daydreamer.idv.tw/rewrite.php/read-62.html
成功建立 SSL 連線後， 用 ssl_read 和 ssl_write 為資料加密傳輸

### 處理交易訊息邏輯
- 對付款方： client 若想做轉帳交易，會先傳送PayRequest#payer#amount#payee 格式的訊息給 server， server 會檢查收款人帳戶是否存在，是否在線以及付款人帳戶餘額是否足夠，
(1)若不在線回傳"FAIL： Payee is not online"
(2)若餘額不足，回傳： "FAIL： Your account balance is not enough"
(3)若條件都符合，回傳 payee 的 port 給 payer 讓他建立 socket 和 SSL連線到 payee， 並傳送 payer#money#payee 訊息給 payee 告知他被轉帳了。 對於 server 而言， 成功回傳 port 後它就會處理交易，更新 payer和 payee 的帳戶餘額

- 對收款方： Client 端在成功登入後， 會開一個 thread 呼叫commectToPeer 函數， listening 等待其他 client 的連線， 如同server， 這裡也做 socket 和 SSL 連線， 但一次只能接收一個連線。 成功連線後， 會接收其他 client 傳入的轉帳訊息， 之後輸出<user>gives you <amount>dollars
