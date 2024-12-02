import streamlit as st
import pandas as pd
from connector import connect_to
import plotly.express as px

st.set_page_config("Homework 12", layout="wide")
st.title('Домашнее задание 12')


@st.cache_data
def load_data(start_date, end_date):
    query = f"""
        select 
        i.invoice_date::date as invoice_date
        , i.total
        , i.billing_country
        , t.track_id 
        , g."name"  as genre_name
    from invoice i 
    join invoice_line il on 
        i.invoice_id = il.invoice_id 
    join track t on 
        il.track_id = t.track_id 
    join genre g on
        t.genre_id = g.genre_id 
    where 
        i.invoice_date between 
        '{start_date}' and '{end_date}'
    ;
    """
    with connect_to() as pg:
        data = pd.read_sql(query, pg)
    return data


st.sidebar.header('Фильтры')
start_date = st.sidebar.date_input('Начало', pd.to_datetime('2021-01-01'))
end_date = st.sidebar.date_input('Конец', pd.to_datetime('2025-12-31'))

df = load_data(start_date, end_date)


def render_line_chart(data):
    st.subheader('Линейный график: сумма продаж по дате инвойса')
    country_filter = st.select_slider(
        'Выберите страну:',
        options = ["Все"] + sorted(data['billing_country'].unique())             
    )
    
    if country_filter != 'Все':
        data = data.query(f'billing_country == "{country_filter}" ') 

    line_chart_data = data.groupby('invoice_date')['total'].sum().reset_index()
    fig = px.line(
        data_frame = line_chart_data,
        x = 'invoice_date',
        y = 'total',
        title='Сумма продаж по дате инвойса',
    )
    st.plotly_chart(fig, use_container_width=True)


def render_bar_chart(data):
    st.subheader('Столбчатая диаграмма: сумма продаж по жанрам')
    genre_filter = st.multiselect(
        'Выберите жанр:',
        options=data['genre_name'].unique(),
        default=data['genre_name'].unique()
    )
    data = data[data['genre_name'].isin(genre_filter)]

    bar_chart_data = data.groupby('genre_name')['total'].sum().reset_index()
    fig = px.bar(
        bar_chart_data,
        x = 'genre_name',
        y = 'total',
        title = 'Сумма продаж по жанрам',   
    )
    st.plotly_chart(fig, use_container_width=True)

col1, col2 = st.columns(2)
with col1:
    render_line_chart(df)

with col2:
    render_bar_chart(df)