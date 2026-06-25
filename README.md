# Phân Tích Rủi Ro Tín Dụng — Home Credit Default Risk

## Tóm tắt dự án
Phân tích 307.511 hồ sơ vay vốn nhằm xác định các yếu tố rủi ro tín dụng 
và xây dựng mô hình dự đoán khả năng vỡ nợ đạt AUC-ROC = 0.7557.

## Bài toán kinh doanh
Home Credit muốn dự đoán khách hàng nào có khả năng vỡ nợ để hỗ trợ 
quyết định cho vay và quản lý rủi ro hiệu quả hơn.

## Dataset
Nguồn: [Kaggle — Home Credit Default Risk](https://www.kaggle.com/c/home-credit-default-risk)

Tải về và đặt vào thư mục `data/raw/`:
- `application_train.csv`
- `bureau.csv`

## Phát hiện chính (Key Findings)
- **Tỷ lệ vỡ nợ tổng thể: 8.1%** — dataset mất cân bằng nặng (91.9% vs 8.1%)
- Nhóm **nghỉ thai sản & thất nghiệp** có tỷ lệ vỡ nợ 40% và 36.4% — 
  cao gấp 4 lần trung bình
- Nhóm **20-30 tuổi** vỡ nợ 11.4% — cao hơn gấp đôi so với nhóm 60-70 tuổi (4.9%)
- Học vấn **Lower secondary** vỡ nợ 10.9% — gấp 6 lần nhóm có bằng Tiến sĩ (1.8%)
- **Điểm tín dụng bên ngoài** (EXT_SOURCE_2, EXT_SOURCE_3) là 2 yếu tố 
  dự đoán quan trọng nhất trong mô hình

## 🛠️ Phương pháp thực hiện
1. **EDA & Phân tích phân khúc** — tỷ lệ vỡ nợ theo nhân khẩu học
2. **Feature Engineering** — tạo CREDIT_INCOME_RATIO, ANNUITY_INCOME_RATIO, AGE_YEARS
3. **Làm sạch dữ liệu** — loại bỏ 41 cột có >50% missing values
4. **Mô hình hóa** — XGBoost với scale_pos_weight để xử lý mất cân bằng dữ liệu

## Kết quả

| Chỉ số | Giá trị |
|--------|---------|
| AUC-ROC | **0.7557** |
| Số features sử dụng | 185 |
| Số mẫu huấn luyện | 246.008 |

## Công nghệ sử dụng
- **Python**: pandas, numpy, matplotlib, seaborn, xgboost, scikit-learn
- **SQL**: SQLite — phân tích phân khúc, window functions
- **Power BI**: Dashboard tương tác 3 trang

## Cấu trúc dự án
credit-risk-analytics/

├── data/

│  ├── raw/          ← đặt file CSV gốc tại đây (không upload lên GitHub)

│  └── processed/    ← dữ liệu sau khi làm sạch

├── notebooks/

│  ├── 01_EDA.ipynb

│  ├── 02_SQL_Analysis.sql

│  └── 03_Modeling.ipynb

├── dashboard/

│  └── credit_risk.pbix

└── README.md
