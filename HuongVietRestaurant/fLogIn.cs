using HuongVietRestaurant.DAO;
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
    public partial class fLogIn : Form
    {
        public fLogIn()
        {
            InitializeComponent();
        }

        private void LogIn_Load(object sender, EventArgs e)
        {

        }

        DataTable Login(string username, string password)
        {
            return LoginDAO.Instance.Login(username, password);
        }

        bool GetTypeOfAccount (DataTable t)
        {
            string id = t.Rows[0].Field<string>("id_owner");
            string type = id.Substring(0,2);
            if (String.Compare(type, "em", true) == 0)
            {
                return true;
            }
            else return false;
        }

        private void btnLogIn_Click(object sender, EventArgs e)
        {
            string username = txbUsername.Text;
            string password = txbPassword.Text;
            DataTable result = Login(username, password);
            if (result.Rows.Count > 0)
            {
                if (GetTypeOfAccount(result))
                {
                    fStaff f = new fStaff();
                    this.Hide();
                    f.ShowDialog();
                    this.Show();
                }
                else
                {
                    fCustomer f = new fCustomer();
                    this.Hide();
                    f.ShowDialog();
                    this.Show();
                }
                
            }
            else
            {
                MessageBox.Show("Invalid username or password!!!");
            }
        }
    }
}
