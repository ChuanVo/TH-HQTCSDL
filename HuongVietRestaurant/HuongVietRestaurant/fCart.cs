using HuongVietRestaurant.DAO;
using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace HuongVietRestaurant
{
    public partial class fCart : Form
    {
        public delegate void SendMessage(string Message);
        public SendMessage Sender;



        public fCart()
        {
            InitializeComponent();
            Sender = new SendMessage(GetMessage);
        }

        private void GetMessage(string Message)
        {
            lsvBillDetail.Tag = Message;
            LoadBill();
        }

        void LoadBill()
        {
            lsvBillDetail.Items.Clear();
            List<Order> billDetail = OrderDAO.Instance.GetOrder(lsvBillDetail.Tag.ToString());
            float subTotal = 0;
            foreach (Order item in billDetail)
            {
                ListViewItem lsvItem = new ListViewItem(item.FoodName.ToString());
                lsvItem.SubItems.Add(item.Unit.ToString());
                lsvItem.SubItems.Add(item.Price.ToString());
                lsvItem.SubItems.Add(item.TotalPrice.ToString());
                subTotal += item.TotalPrice;
                lsvBillDetail.Items.Add(lsvItem);
            }
            CultureInfo culture = new CultureInfo("vi-VN");

            //Thread.CurrentThread.CurrentCulture = culture;

            txtSubtotal.Text = subTotal.ToString("c", culture);
        }
    }
}
