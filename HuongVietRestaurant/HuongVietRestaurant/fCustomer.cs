using HuongVietRestaurant.DAO;
using HuongVietRestaurant.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace HuongVietRestaurant
{
    public partial class fCustomer : Form
    {
        fCart f = new fCart();
        private string agencyID = null;
        private string categoryID = null;


        public fCustomer()
        {
            InitializeComponent();
            //LoadAgency();
            //LoadCategory();
            
            panelInfo.Hide();

        }

        #region method

        void LoadAgency()
        {
            List<Agency> listAgency = AgencyDAO.Instance.GetListAgency();
            cboAgency.DataSource = listAgency;
            cboAgency.DisplayMember = "Name";
        }

        void LoadCategory()
        {
            List<FoodCategory> foodCategories = FoodCategoryDAO.Instance.GetListFoodCategory();
            cboCategory.DataSource = foodCategories;
            cboCategory.DisplayMember = "Name";
        }

        void LoadMenu(string agencyID, string categoryID)
        {
            flpMenu.Controls.Clear();
            List<DTO.Menu> list = MenuDAO.Instance.GetMenu(agencyID, categoryID);
            foreach (DTO.Menu item in list)
            {
                Button btn = new Button() { Width = MenuDAO.btnWidth, Height = MenuDAO.btnHeight };
                //btn.Image = new Bitmap(Application.StartupPath + item.Image);

                btn.Click += btn_Click;
                btn.Tag = item;


                btn.Text = item.FoodName + "\n" + item.Price + "\nRemain: " + item.Unit;
                
                

                flpMenu.Controls.Add(btn);
            }
        }

        #endregion

        #region events
        private void cboAgency_SelectedIndexChanged(object sender, EventArgs e)
        {
           
        }

        private void btn_Click(object sender, EventArgs e)
        {
            DTO.Menu info = ((sender as Button).Tag as DTO.Menu);
            txtFoodName.Text = info.FoodName;

            //Byte[] i = (byte[])DataRow["hinhAnh"];
            //MemoryStream stmBLOBData = new MemoryStream(i)
            //ptbFood.BackgroundImage = Image.FromFile(info.Image);
            txtFoodInfo.Text = "Description: " + info.Image + Environment.NewLine
                + "Price: " + info.Price + Environment.NewLine + "Remain amount: " + info.Unit;
            btnAddToCart.Tag = info.FoodID;
            panelInfo.Show();
        }

        private void fCustomer_Load(object sender, EventArgs e)
        {

        }

        private void cboAgency_DropDown(object sender, EventArgs e)
        {
            LoadAgency();
        }

        private void cboCategory_DropDown(object sender, EventArgs e)
        {
            LoadCategory();
        }


        private void cboCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            ComboBox cbo = sender as ComboBox;

            if (cbo.SelectedItem == null) return;

            FoodCategory selected = cbo.SelectedItem as FoodCategory;

            categoryID = selected.ID;
            //LoadMenu(agencyID);

            //List<Control> list = new List<Control>();
            //foreach (Control control in flpMenu.Controls)
            //{
            //    list.Add(control);
            //}

            //foreach (Control control in list)
            //{
            //    if(String.Compare(((control.Tag) as DTO.Menu).CategoryID.ToString(), categoryID, true) != 0)
            //    {
            //        flpMenu.Controls.Remove(control);
            //        control.Dispose();
            //    }
            //}

        }

        private void btnAddToCart_Click(object sender, EventArgs e)
        {
            if(numericUpDown1.Value == 0)
            {
                MessageBox.Show("The number of dish can not be 0", "Notice", MessageBoxButtons.OK);
            }
            else
            {
                cboAgency.Enabled = false;
                string id_food = btnAddToCart.Tag.ToString();
                int unit = (int)numericUpDown1.Value;
                Agency selected = cboAgency.SelectedItem as Agency;

                string id_agency = selected.ID;
                string id_bill = "bill_" + BillDAO.Instance.GetMaxIDBill();

                
                if (btnCart.Enabled == false)
                {
                    BillDAO.Instance.InsertBill(id_bill, id_agency);
                    BillDetailDAO.Instance.InsertBillInfo(id_bill, id_food, unit);

                    btnCart.Tag = id_bill;
                    btnCart.Enabled = true;
                    btnCart.BackColor = Color.Aqua;
                }
                else
                {
                    BillDetailDAO.Instance.InsertBillInfo(btnCart.Tag.ToString(), id_food, unit);


                }
                MenuDAO.Instance.UpdateMenu(id_agency, id_food, unit);
                numericUpDown1.Value = 0;
                panelInfo.Hide();
                LoadMenu(id_agency, categoryID);
                //MessageBox.Show("Success!","", MessageBoxButtons.OK);
            }
        }

        private void btnCart_Click(object sender, EventArgs e)
        {
            f.Sender(btnCart.Tag.ToString());
            this.Hide();
            f.ShowDialog();
            this.Show();
        }
        #endregion

        private void ptbFood_Click(object sender, EventArgs e)
        {

        }

        //View unit >=1
        private void button1_Click(object sender, EventArgs e)
        {
            List<Control> list = new List<Control>();
            foreach (Control control in flpMenu.Controls)
            {
                list.Add(control);
            }

            foreach (Control control in list)
            {
                if ((int)((control.Tag) as DTO.Menu).Unit == 0)
                {
                    flpMenu.Controls.Remove(control);
                    control.Dispose();
                }
            }

        }

        // View price < 50k
        private void button1_Click_1(object sender, EventArgs e)
        {
            List<Control> list = new List<Control>();
            foreach (Control control in flpMenu.Controls)
            {
                list.Add(control);
            }

            foreach (Control control in list){ 

                if ((int)((control.Tag) as DTO.Menu).Price > 50000)
                {
                    flpMenu.Controls.Remove(control);
                    control.Dispose();
                }
            }
        }

        private void cboAgency_SelectedValueChanged(object sender, EventArgs e)
        {
            cboCategory.Enabled = true;
            cboCategory.Text = null;
            btnViewEnableFood.Enabled = true;
            btnViewLess50.Enabled = true;

            ComboBox cbo = sender as ComboBox;

            if (cbo.SelectedItem == null) return;

            Agency selected = cbo.SelectedItem as Agency;

            agencyID = selected.ID;
            btnView.Enabled = true;
            
        }

        private void btnView_Click(object sender, EventArgs e)
        {
            LoadMenu(agencyID, categoryID);

        }
    }


}
