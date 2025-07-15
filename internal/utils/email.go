package utils

import (
	"fmt"
	"net/smtp"
	"os"
)

func SendVerificationEmail(toEmail, token string) error {
	from := "vanaraj1018@gmail.com"
	password := os.Getenv("SMTP_PASS")
	smtpHost := "smtp.gmail.com"
	smtpPort := "587"

	verificationLink := fmt.Sprintf("http://localhost:8080/verify?token=%s",token)
	subject := "Email Verification\n"
	body := fmt.Sprintf("Click the link to verify your email: %s", verificationLink)
	message := []byte(subject + "\n" + body)

	auth := smtp.PlainAuth("",from,password,smtpHost)
	return smtp.SendMail(smtpHost+":"+smtpPort, auth, from, []string{toEmail}, message)
}