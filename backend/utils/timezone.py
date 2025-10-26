"""
Cấu hình múi giờ cho dự án
Múi giờ: Asia/Ho_Chi_Minh (UTC+7)
"""
from datetime import datetime
import pytz

# Múi giờ Hồ Chí Minh
TIMEZONE = pytz.timezone('Asia/Ho_Chi_Minh')

def get_current_time():
    """Lấy thời gian hiện tại theo múi giờ Hồ Chí Minh"""
    return datetime.now(TIMEZONE)

def utc_to_local(utc_dt):
    """Chuyển đổi UTC sang múi giờ Hồ Chí Minh"""
    if utc_dt is None:
        return None
    if utc_dt.tzinfo is None:
        utc_dt = pytz.utc.localize(utc_dt)
    return utc_dt.astimezone(TIMEZONE)

def local_to_utc(local_dt):
    """Chuyển đổi múi giờ Hồ Chí Minh sang UTC"""
    if local_dt is None:
        return None
    if local_dt.tzinfo is None:
        local_dt = TIMEZONE.localize(local_dt)
    return local_dt.astimezone(pytz.utc)

