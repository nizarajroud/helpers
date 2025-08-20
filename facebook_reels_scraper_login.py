from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from webdriver_manager.chrome import ChromeDriverManager
import time

def facebook_login(driver, email, password):
    """Logs into Facebook using the provided credentials"""
    driver.get("https://www.facebook.com/login")
    time.sleep(3)

    email_box = driver.find_element(By.ID, "email")
    password_box = driver.find_element(By.ID, "pass")

    email_box.send_keys(email)
    password_box.send_keys(password)
    password_box.send_keys(Keys.RETURN)

    time.sleep(5)  # wait for login to complete

def get_reel_links(page_url, email, password, scrolls=5, delay=3):
    # Setup Chrome (headless mode optional)
    options = Options()
    # Comment this line if you want to see the browser
    options.add_argument("--headless=new")
    options.add_argument("--disable-blink-features=AutomationControlled")

    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

    # Login first
    facebook_login(driver, email, password)

    # Open reels page
    driver.get(page_url)
    time.sleep(delay)

    # Scroll to load reels
    for _ in range(scrolls):
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(delay)

    # Extract reel links
    links = driver.find_elements(By.XPATH, "//a[contains(@href, '/reel/')]")
    reel_urls = list(set([l.get_attribute("href").split('?')[0] for l in links if l.get_attribute("href")]))

    driver.quit()
    return reel_urls


if __name__ == "__main__":
    # 🔑 Enter your Facebook credentials here
    FB_EMAIL = "your_email_here"
    FB_PASS = "your_password_here"

    # Example reels page
    url = "https://www.facebook.com/M.Elkotby2002/reels/"
    reels = get_reel_links(url, FB_EMAIL, FB_PASS, scrolls=10, delay=3)

    print(f"\n✅ Found {len(reels)} reels:")
    for r in reels:
        print(r)
