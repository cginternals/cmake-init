
#include "MainWindow.h"

#include <QBoxLayout>
#include <QLabel>
#include <QSpinBox>

#include <fiblib/Fibonacci.h>


MainWindow::MainWindow()
{
    // Create content widget
    QWidget * content = new QWidget(this);
    setCentralWidget(content);

    // Create layout
    QBoxLayout * layout = new QVBoxLayout();
    content->setLayout(layout);

    // Add title
    QLabel * title = new QLabel(content);
    title->setText("Please enter n:");
    layout->addWidget(title);

    // Add input field
    QSpinBox * editNumber = new QSpinBox(content);
    editNumber->setMinimum(0);
    layout->addWidget(editNumber);

    // Add result
    QLabel * result = new QLabel(content);
    result->setText("Fib(0) = 0");
    layout->addWidget(result);

    // When input changes, calculate and output the fibonacci number
    connect(editNumber, static_cast<void (QSpinBox::*)(int)>(&QSpinBox::valueChanged), [result] (int n)
    {
        fiblib::Fibonacci fib;
        result->setText("Fib(" + QString::number(n) + ") = " + QString::number(fib(n)));
    });
}

MainWindow::~MainWindow()
{
}