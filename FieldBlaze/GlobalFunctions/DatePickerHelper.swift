import UIKit

class DatePickerHelper {

    static func showInlineDatePicker(centerIn parentView: UIView,
                                     targetLabel: UILabel) {

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemGroupedBackground
        container.layer.cornerRadius = 12
        container.clipsToBounds = true

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.cornerRadius = 10
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(datePicker)
        container.addSubview(doneButton)
        parentView.addSubview(container)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
            datePicker.topAnchor.constraint(equalTo: container.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8),
            doneButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            doneButton.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])

        // Use a custom target object to keep the callback working
        let handler = DatePickerHandler(datePicker: datePicker, label: targetLabel, container: container)
        doneButton.addTarget(handler, action: #selector(DatePickerHandler.doneButtonTapped(_:)), for: .touchUpInside)

        // Store the handler in the button to retain it
        objc_setAssociatedObject(doneButton, "handler", handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

/// Helper class to handle the selector call properly
private class DatePickerHandler: NSObject {
    let datePicker: UIDatePicker
    let label: UILabel
    let container: UIView

    init(datePicker: UIDatePicker, label: UILabel, container: UIView) {
        self.datePicker = datePicker
        self.label = label
        self.container = container
    }

    @objc func doneButtonTapped(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        label.text = formatter.string(from: datePicker.date)
        label.textColor = .black
        container.removeFromSuperview()
    }
}
