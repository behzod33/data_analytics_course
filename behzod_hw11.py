import streamlit as st
import pandas as pd
from connector import connect_to
import plotly.express as px


query = 'select * from invoice'

with connect_to() as conn:
    df = pd.read_sql(query, conn)

st.set_page_config("Chinook Sales Report", layout="wide")
st.title('Chinook Sales Report')

st.sidebar.header('Фильтры')

year = st.sidebar.selectbox(
    'Выберите год:', 
    sorted(df['invoice_date'].dt.year.unique()), 
    index=0
)
country = st.sidebar.multiselect(
    'Выберите страну:', 
    df['billing_country'].unique(),
    default=df['billing_country'].unique()
)
min_total = st.sidebar.slider(
    'Минимальная сумма покупки:',
    float(df['total'].min()),
    float(df['total'].max())
)

filtered_data = df[
    (df['invoice_date'].dt.year == year) &
    (df['billing_country'].isin(country)) &
    (df['total'] >= min_total)
]

monthly_sales = filtered_data.groupby(
    filtered_data['invoice_date'].dt.to_period('M')).agg(
    total=('total', 'sum')
).reset_index()

monthly_sales['invoice_date'] =\
    monthly_sales['invoice_date'].dt.to_timestamp()

fig1 = px.line(
    monthly_sales,
    x='invoice_date',
    y='total',
    title='Доход по месяцам'
)

fig2 = px.histogram(
    filtered_data,
    x='total',
    nbins=12,
    title='Доход по месяцам'
)

st.plotly_chart(fig1, use_container_width=True)
st.plotly_chart(fig2, use_container_width=True)

# if st.checkbox('Показать данные'):
#     st.dataframe(filtered_data)