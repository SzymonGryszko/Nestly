using System.ComponentModel.DataAnnotations;

public class User
{
    [Key]
    [Required]
    [StringLength(128)]
    public string FirebaseUid { get; set; }

    [Required]
    [StringLength(256)]
    [EmailAddress]
    public string Email { get; set; }

    [StringLength(256)]
    public string FullName { get; set; }

    [StringLength(512)]
    public string ProfilePictureUrl { get; set; }

    [Required]
    public DateTime CreatedAt { get; set; }

    [Required]
    public DateTime LastLogin { get; set; }

    [StringLength(50)]
    public string Role { get; set; }
}
