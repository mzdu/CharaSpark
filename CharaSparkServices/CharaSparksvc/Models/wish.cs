//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CharaSparksvc.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class wish
    {
        public int wish_id { get; set; }
        public string wish_name { get; set; }
        public Nullable<int> wish_status_id { get; set; }
        public System.DateTime create_date { get; set; }
        public string created_by { get; set; }
        public Nullable<System.DateTime> update_date { get; set; }
        public bool is_active { get; set; }
        public Nullable<System.DateTime> start_date { get; set; }
        public Nullable<System.DateTime> end_date { get; set; }
        public int user_id { get; set; }
        public Nullable<int> fullfiller_user_id { get; set; }
        public string gps_coordinates { get; set; }
        public Nullable<decimal> donation_amount { get; set; }
        public string charity_name { get; set; }
        public string charity_email { get; set; }
        public int donation_status_id { get; set; }
    
        public virtual donation_status donation_status { get; set; }
        public virtual user user { get; set; }
        public virtual wish_status wish_status { get; set; }
    }
}