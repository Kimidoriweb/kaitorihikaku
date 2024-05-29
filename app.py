import os
from flask import Flask, render_template, request
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from concurrent.futures import ThreadPoolExecutor
import time
import shutil
import logging

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'static/uploads'

# ログの設定
logging.basicConfig(level=logging.INFO)

@app.route('/', methods=['GET', 'POST'])
def index():
    screenshots = []
    if request.method == 'POST':
        jan_code = request.form['jan_code']
        clear_upload_folder(app.config['UPLOAD_FOLDER'])
        with ThreadPoolExecutor(max_workers=5) as executor:
            futures = [
                executor.submit(get_screenshot_kaitorishouten, jan_code),
                executor.submit(get_screenshot_kaitori1chome, jan_code),
                executor.submit(get_screenshot_rudeya, jan_code),
                executor.submit(get_screenshot_mobile1, jan_code),
                executor.submit(get_screenshot_wiki, jan_code)
            ]
            for future in futures:
                try:
                    result = future.result()
                    if result:  # Noneでない場合のみ追加
                        screenshots.append(result)
                except Exception as e:
                    logging.error(f"Error occurred: {e}")

    return render_template('index.html', screenshots=screenshots)

def clear_upload_folder(folder):
    for filename in os.listdir(folder):
        file_path = os.path.join(folder, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            logging.error(f'Failed to delete {file_path}. Reason: {e}')

def get_screenshot_kaitorishouten(jan_code):
    return get_screenshot(
        "買取商店",
        "https://www.kaitorishouten-co.jp/",
        '//*[@id="search_name"]',
        '//*[@id="search-content"]',
        jan_code
    )

def get_screenshot_kaitori1chome(jan_code):
    return get_screenshot(
        "買取1丁目",
        "https://www.1-chome.com/elec",
        '//*[@id="key-search-box"]',
        '//*[@id="search-result-area"]/div/article/div/div[1]/div[1]',
        jan_code
    )

def get_screenshot_rudeya(jan_code):
    return get_screenshot(
        "ルデヤ",
        "https://kaitori-rudeya.com/search/index/-/-/-/-/-",
        '//*[@id="keyword"]',
        '//*[@id="main_wrap"]/section[2]/div[1]/div[2]',
        jan_code
    )

def get_screenshot_mobile1(jan_code):
    return get_screenshot(
        "モバイル1番",
        "https://www.mobile-ichiban.com/",
        '//*[@id="G01SearchIpt"]',
        '//*[@id="dateAndPager"]/div[2]/table/tbody',
        jan_code
    )

def get_screenshot_wiki(jan_code):
    return get_screenshot(
        "ゲーム買取ウィキ",
        "https://gamekaitori.jp/",
        '//*[@id="q"]',
        '//*[@id="layout_x"]/div[2]/div[2]/div/div[3]/ul/li[1]/span',
        jan_code
    )

def get_screenshot(site_name, url, search_box_xpath, result_xpath, jan_code):
    # WebDriverのセットアップ
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')  # ヘッドレスモードを有効にする
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    
    driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=options)

    try:
        # サイトにアクセス
        logging.info(f"Accessing site: {url}")
        driver.get(url)
        time.sleep(2)  # ページが完全に読み込まれるまで少し待つ

        # ページのソースを保存してデバッグに利用
        with open(f"{app.config['UPLOAD_FOLDER']}/page_source_{site_name}.html", "w", encoding='utf-8') as f:
            f.write(driver.page_source)

        # 必要なクッキーを追加（例としてCSRFトークンを追加）
        # driver.add_cookie({"name": "Eccube-Csrf-Token", "value": "your-csrf-token"})

        # XPathを使用して検索ボックスを見つけて、JANコードを入力
        search_box = driver.find_element(By.XPATH, search_box_xpath)
        search_box.send_keys(jan_code)
        search_box.send_keys(Keys.RETURN)

        # 結果が表示されるまで待機（適切な待機時間を設定）
        time.sleep(5)  # 5秒待機

        # XPathを使用して検索結果の要素を取得
        search_content = driver.find_element(By.XPATH, result_xpath)

        # スクリーンショットを保存するパスを設定
        filename = f'screenshot_{url.split("//")[1].split(".")[0]}_{int(time.time())}.png'
        screenshot_path = os.path.join(app.config['UPLOAD_FOLDER'], filename).replace("\\", "/")
        search_content.screenshot(screenshot_path)
        logging.info(f"Screenshot saved: {screenshot_path}")
        return {"site_name": site_name, "screenshot_path": screenshot_path}
    except Exception as e:
        logging.error(f"Failed to get screenshot for {site_name} from {url}. Reason: {e}")
        return None
    finally:
        # ブラウザを閉じる
        driver.quit()

if __name__ == '__main__':
    if not os.path.exists(app.config['UPLOAD_FOLDER']):
        os.makedirs(app.config['UPLOAD_FOLDER'])
    port = int(os.environ.get("PORT", 5000))  # PORT環境変数を取得し、デフォルトは5000
    app.run(host='0.0.0.0', port=port, debug=True)
