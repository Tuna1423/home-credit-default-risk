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

## SQL Analysis — Chi tiết phân tích

### Query 1: Default Rate theo Giới tính & Học vấn
| Giới tính | Học vấn | Tổng hồ sơ | Tỷ lệ vỡ nợ |
|-----------|---------|------------|-------------|
| Nam | Lower secondary | 1.505 | **13.49%** |
| Nam | Secondary/special | 74.924 | 11.36% |
| Nữ | Lower secondary | 2.311 | 9.26% |
| Nữ | Higher education | 50.289 | 4.85% |
| Nữ | Academic degree | 100 | 3.00% |

→ **Insight:** Nam giới có học vấn thấp là nhóm rủi ro cao nhất (13.49%)

---

### Query 2: Risk Ranking theo Loại thu nhập
| Hạng | Loại thu nhập | Tổng | Tỷ lệ vỡ nợ |
|------|--------------|------|-------------|
| 1 | Maternity leave | 5 | **40.00%** |
| 2 | Unemployed | 22 | **36.36%** |
| 3 | Working | 158.774 | 9.59% |
| 4 | Commercial associate | 71.617 | 7.48% |
| 6 | Pensioner | 55.362 | 5.39% |

→ **Insight:** Nhóm không có thu nhập ổn định rủi ro cao gấp 4x nhóm đi làm

---

### Query 3: Running Total Default theo Nhóm tuổi
| Nhóm tuổi | Tổng hồ sơ | Vỡ nợ | Tỷ lệ | Cộng dồn |
|-----------|-----------|-------|-------|----------|
| 20-30 | 52.806 | 6.019 | **11.40%** | 6.019 |
| 31-40 | 83.117 | 7.719 | 9.29% | 13.738 |
| 41-50 | 74.401 | 5.618 | 7.55% | 19.356 |
| 51-60 | 67.819 | 4.024 | 5.93% | 23.380 |
| 60+ | 29.368 | 1.445 | **4.92%** | 24.825 |

→ **Insight:** Nhóm 20-30 tuổi chiếm 24% tổng hồ sơ nhưng đóng góp **24% tổng số vỡ nợ**

---

### Query 4: Join Bureau — Nợ quá hạn theo Loại hợp đồng
| Loại hợp đồng | Loại thu nhập | Tỷ lệ vỡ nợ | TB nợ quá hạn |
|--------------|--------------|-------------|---------------|
| Cash loans | Working | 9.94% | 68.88 |
| Cash loans | Commercial associate | 7.84% | 37.27 |
| Revolving loans | Working | 6.43% | **124.62** |
| Cash loans | Pensioner | 5.47% | 6.55 |

→ **Insight:** Revolving loans có tỷ lệ vỡ nợ thấp hơn nhưng số nợ quá hạn trung bình **cao gấp đôi** Cash loans
## Công nghệ sử dụng
- **Python**: pandas, numpy, matplotlib, seaborn, xgboost, scikit-learn
- **SQL**: SQLite — phân tích phân khúc, window functions
- **Power BI**: Dashboard tương tác 3 trang

## Cấu trúc dự án
credit-risk-analytics/

├── data/

│  ├── raw/          ← đặt file CSV gốc tại đây (không upload lên GitHub)

│  └── processed/    ← dữ liệu sau khi làm sạch

│  ── 01_EDA.ipynb

│  ── 02_SQL_Analysis.sql

│  ── 03_Modeling.ipynb

├── dashboard/

│  └── credit_risk.pbix

└── README.md
