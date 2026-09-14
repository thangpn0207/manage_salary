# Store Config and ASO (App Store Optimization)

This directory contains metadata and configurations for releasing the app to Google Play Store and Apple App Store. It is structured to separate content by platform and language to make deployment easier (compatible with fastlane or manual copy-pasting).

## Directory Structure

```
store/
├── README.md                   # Tài liệu hướng dẫn & metadata stores
├── app_icon_512.png            # Master App Icon (512x512 PNG, Nordic Bản C)
├── app_icon.svg                # Master App Icon Vector (SVG)
├── banner_vi_1024x500.png      # Feature Graphic Banner Tiếng Việt (1024x500 PNG)
├── banner_en_1024x500.png      # Feature Graphic Banner English (1024x500 PNG)
├── app_store/
│   ├── en-US/                  # iOS English Assets & Metadata
│   │   ├── listing.md          # Title, Subtitle, Keywords, Description
│   │   └── screenshots/        # 5 Screenshot Cards (1080x1920 px, 9:16)
│   │       ├── 1_attendance.png
│   │       ├── 2_salary_ot.png
│   │       ├── 3_export_reports.png
│   │       ├── 4_budget_expense.png
│   │       └── 5_trip_travel.png
│   └── vi-VN/                  # iOS Vietnamese Assets & Metadata
│       ├── listing.md          # Tiêu đề, Phụ đề, Từ khoá, Mô tả
│       └── screenshots/        # 5 Screenshot Cards (1080x1920 px, 9:16)
│           ├── 1_attendance.png
│           ├── 2_salary_ot.png
│           ├── 3_export_reports.png
│           ├── 4_budget_expense.png
│           └── 5_trip_travel.png
└── play_store/
    ├── en-US/                  # Android English Assets & Metadata
    │   ├── icon_512.png        # 512x512 App Icon
    │   ├── feature_graphic.png # 1024x500 Feature Graphic Banner
    │   ├── listing.md          # App Name, Short Desc (<=80 char), Full Desc
    │   └── screenshots/        # 5 Phone Screenshots (1080x1920 px, 9:16)
    │       ├── 1_attendance.png
    │       ├── 2_salary_ot.png
    │       ├── 3_export_reports.png
    │       ├── 4_budget_expense.png
    │       └── 5_trip_travel.png
    └── vi-VN/                  # Android Vietnamese Assets & Metadata
        ├── icon_512.png        # 512x512 App Icon
        ├── feature_graphic.png # 1024x500 Feature Graphic Banner
        ├── listing.md          # Tên ứng dụng, Mô tả ngắn (<=80 ký tự), Mô tả đầy đủ
        └── screenshots/        # 5 Phone Screenshots (1080x1920 px, 9:16)
            ├── 1_attendance.png
            ├── 2_salary_ot.png
            ├── 3_export_reports.png
            ├── 4_budget_expense.png
            └── 5_trip_travel.png
```

## SEO & ASO Strategy Applied
Based on best practices and marketing ideas for app growth:
1. **Title & Subtitle/Short Description:** Used high-volume search terms like "Expense Tracker", "Quản Lý Thu Chi", "Salary & Shift", "Chấm Công Tính Lương", "Budget". Placed primary keywords in the app title to maximize indexing weight.
2. **Keywords (iOS):** Used comma-separated strings maximizing the 100-character limit. For Vietnamese, unaccented syllables have been included to capture users searching without accents.
3. **5-Screen Visual Marketing Funnel:**
   - **Card 1 (Core Daily Hook):** Chấm công 1 chạm / 1-Tap Attendance (Shift, overtime, meal)
   - **Card 2 (High Value Hook):** Tự động tính lương & OT / Auto Salary & Overtime Calc
   - **Card 3 (Professional Utility):** Xuất báo cáo nhanh / Export Timesheet & Paystub (PDF & Excel)
   - **Card 4 (Finance Foundation):** Quản lý thu chi & Hạn mức / Smart Budget & Money Tracker
   - **Card 5 (Social Retention):** Sổ tay du lịch & Chia tiền nhóm / Trip Log & Group Bill Split
4. **Graphic Standards:**
   - App Icon: 512x512 32-bit PNG with Android 13-16 Adaptive & Monochrome support.
   - Feature Graphic: 1024x500 px with safe margin (>15% padding from borders).
   - Screenshots: 1080x1920 px (9:16 aspect ratio, high-res crisp typography and mockups).
