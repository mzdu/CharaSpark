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
    
    public partial class donation_status
    {
        public donation_status()
        {
            this.wishes = new HashSet<wish>();
        }
    
        public int donation_status_id { get; set; }
        public string donation_status_desc { get; set; }
    
        public virtual ICollection<wish> wishes { get; set; }
    }
}
