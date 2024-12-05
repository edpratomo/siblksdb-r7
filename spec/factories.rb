FactoryBot.define do

  factory :admission do
    name { Faker::Name.name }
    birthplace { Faker::Address.city }
    birthdate { Faker::Date.birthday }
    sex { Faker::Gender.binary_type.downcase }
    phone { Faker::PhoneNumber.unique.cell_phone }
    email { Faker::Internet.unique.email }
  end

  factory :admission_fee do
    amount { 100_000 }
    active_since { 1.second.ago }
  end

  factory :reg_course_fee do
    amount { 400_000 }
    course { Course.first }
    active_since { 1.second.ago }
  end

  factory :int_course_fee do
    amount { 500_000 }
    course { Course.first }
    active_since { 1.second.ago }
  end

  factory :ext_course_fee do
    amount { 100_000 }
    course { Course.first }
    active_since { 1.second.ago }
  end

  factory :book_uniform_fee do
    amount { 125_000_000 }
    program { Program.first }
    active_since { 1.second.ago }
  end
  
  factory :admission_invoice, class: "Invoice" do
    invoiceable { association :admission }
    amount { 0 }
  end
  
  factory :student_invoice, class: "Invoice" do
    invoiceable { Student.last }
    amount { 0 }
  end

  factory :invoice_item do
    course { Course.first }
    fee { association :reg_course_fee }
    description { "Biaya kursus reguler #{Course.first.name}" }
  end

  factory :reg_course_invoice_item, class: "InvoiceItem" do
    course { Course.first }
    fee { association :reg_course_fee }
    description { "Biaya kursus reguler #{Course.first.name}" }
    invoice { association :student_invoice }
  end

  factory :int_course_invoice_item, class: "InvoiceItem"  do
    course { Course.first }
    fee { association :int_course_fee }
    description { "Biaya kursus intensif #{Course.first.name}" }
    invoice { association :student_invoice }
  end

  factory :ext_course_invoice_item, class: "InvoiceItem"  do
    course { Course.first }
    fee { association :ext_course_fee }
    description { "Biaya kursus tambahan #{Course.first.name}" }
    invoice { association :student_invoice }
  end
end
