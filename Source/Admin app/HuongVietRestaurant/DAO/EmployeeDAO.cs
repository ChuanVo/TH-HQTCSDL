using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HuongVietRestaurant.DAO
{
    class EmployeeDAO
    {
        private static EmployeeDAO instance;
        private object Datatable;

        private EmployeeDAO() { }

        public static EmployeeDAO Instance
        {
            get { if (instance == null) instance = new EmployeeDAO(); return EmployeeDAO.instance; }
            private set { EmployeeDAO.instance = value; }
        }

        public DataTable GetListEmployee()
        {
            string query = "EXEC PROC_PHANTOM_T1_LAM ";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            return data;
        }

        public bool UpdateGmailEm(string id, string Gmail)
        {
            string query = "EXEC PROC_DIRTYREAD_T1_LAM @id_employee = '" + id + "', @gmail = '" + Gmail + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool UpdateNameEm(string id, string name)
        {
            string query = "EXEC PROC_DIRTYREAD_T1_TRUNGDUC @id_employee = '" + id + "', @name = N'" + name + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool AddEm(string id, string name, string email, string card, string pos, string address, string ward, string district, string city, string agency)
        {
            string query = "EXEC usp_AddAddress @number_street='" + address + "',@ward='" + ward + "',@district='" + district + "',@city='" + city + "'";

            int result = DataProvider.Instance.ExecuteNonQuery(query);

            query = "EXEC PROC_PHANTOM_T2_LAM @id_employee='" + id + "', @name='" + name + "', @gmail='" + email + "', @id_card='" + card + "', @position='" + pos + "', @agency='" + agency + "'";

            result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }
    }
}
