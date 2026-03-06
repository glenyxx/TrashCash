package com.glenyxx.studentgradecalculatorkotlinversion

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.tooling.preview.Preview
import com.glenyxx.studentgradecalculatorkotlinversion.ui.theme.StudentGradeCalculatorKotlinVersionTheme

data class Student(
    val name: String,
    val score: Double?
)

fun calculateGrade(score: Double?): String {
    val actualScore = score ?: 0.0
    return when {
        actualScore >= 90 -> "A"
        actualScore >= 80 -> "B"
        actualScore >= 70 -> "C"
        actualScore >= 60 -> "D"
        else              -> "F"
    }
}

fun isValidScore(student: Student): Boolean {
    val score = student.score ?: return false
    return score in 0.0..100.0
}

fun formatStudentSummary(student: Student): String {
    val scoreDisplay = student.score?.toString() ?: "No score recorded"
    val grade = calculateGrade(student.score)
    return "${student.name.padEnd(10)} | Score: ${scoreDisplay.padEnd(18)} | Grade: $grade"
}

fun processStudents(students: List<Student>, action: (Student) -> Unit) {
    students.forEach { student -> action(student) }
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        val students = listOf(
            Student(name = "Jenny",    score = 85.5),
            Student(name = "Rita",     score = null),
            Student(name = "Precious", score = 52.0),
            Student(name = "Glenys",   score = 93.0),
            Student(name = "Paola",    score = 70.0)
        )

        // ── TASK 2B: filter — students who passed (score >= 50) ──
        val passedStudents = students.filter { student ->
            val score = student.score ?: 0.0
            score >= 50.0
        }

        // ── TASK 2C: map — transform each student into a grade summary string ──
        val gradeSummaries = students.map { student ->
            "${student.name} → ${calculateGrade(student.score)}"
        }

        // ── TASK 2D: filter — only students with valid scores (0–100) ──
        val validStudents = students.filter { isValidScore(it) }

        // ── TASK 3A: Custom higher-order function with a lambda ──
        // Lambda flags any student scoring below 60 as at-risk
        val atRiskStudents = mutableListOf<Student>()
        processStudents(students) { student ->
            val score = student.score ?: 0.0
            if (score < 60.0) atRiskStudents.add(student)
        }

        // ── TASK 3B: filter — honour roll (Grade A only) ──
        val honourRoll = students.filter { calculateGrade(it.score) == "A" }

        setContent {
            StudentGradeCalculatorKotlinVersionTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    StudentReportScreen(
                        students        = students,
                        passedStudents  = passedStudents,
                        gradeSummaries  = gradeSummaries,
                        validStudents   = validStudents,
                        atRiskStudents  = atRiskStudents,
                        honourRoll      = honourRoll,
                        modifier        = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
}

@Composable
fun StudentReportScreen(
    students       : List<Student>,
    passedStudents : List<Student>,
    gradeSummaries : List<String>,
    validStudents  : List<Student>,
    atRiskStudents : List<Student>,
    honourRoll     : List<Student>,
    modifier       : Modifier = Modifier
) {
    Column(
        modifier = modifier
            .padding(16.dp)
            .verticalScroll(rememberScrollState())
    ) {
        Text(
            text = "Student Grade Calculator",
            fontSize = 22.sp,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(bottom = 16.dp)
        )

        SectionHeader(title = "Full Student Report")
        students.forEach { student ->
            StudentCard(student = student)
            Spacer(modifier = Modifier.height(12.dp))
        }

        SectionHeader(title = "Passed Students (Score ≥ 50)")
        passedStudents.forEach { student ->
            StudentCard(student = student)
            Spacer(modifier = Modifier.height(12.dp))
        }

        SectionHeader(title = "Grade Summary (map)")
        gradeSummaries.forEach { summary ->
            Text(
                text = summary,
                fontSize = 14.sp,
                modifier = Modifier.padding(vertical = 4.dp)
            )
        }
        Spacer(modifier = Modifier.height(12.dp))

        SectionHeader(title = "Valid Scores Only (0–100)")
        validStudents.forEach { student ->
            StudentCard(student = student)
            Spacer(modifier = Modifier.height(12.dp))
        }

        SectionHeader(title = "⚠ At-Risk Students (Score < 60)")
        if (atRiskStudents.isEmpty()) {
            Text(text = "No at-risk students.", fontSize = 14.sp)
            Spacer(modifier = Modifier.height(12.dp))
        } else {
            atRiskStudents.forEach { student ->
                StudentCard(student = student)
                Spacer(modifier = Modifier.height(12.dp))
            }
        }

        SectionHeader(title = "Honour Roll (Grade A)")
        if (honourRoll.isEmpty()) {
            Text(text = "No students achieved an A.", fontSize = 14.sp)
            Spacer(modifier = Modifier.height(12.dp))
        } else {
            honourRoll.forEach { student ->
                StudentCard(student = student)
                Spacer(modifier = Modifier.height(12.dp))
            }
        }
    }
}

@Composable
fun SectionHeader(title: String) {
    Text(
        text = title,
        fontSize = 16.sp,
        fontWeight = FontWeight.Bold,
        color = Color.White,
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp)
            .then(Modifier.padding(horizontal = 10.dp, vertical = 6.dp))
    )
    Spacer(modifier = Modifier.height(8.dp))
}

@Composable
fun StudentCard(student: Student) {
    val grade = calculateGrade(student.score)
    val scoreDisplay = student.score?.toString() ?: "No score recorded"

    val gradeColor = when (grade) {
        "A"  -> Color(0xFF388E3C)
        "B"  -> Color(0xFF1976D2)
        "C"  -> Color(0xFFF57C00)
        "D"  -> Color(0xFFFBC02D)
        else -> Color(0xFFD32F2F)
    }

    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(
                text = student.name.uppercase(),
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold
            )
            Spacer(modifier = Modifier.height(6.dp))
            Text(text = "Score : $scoreDisplay", fontSize = 15.sp)
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = "Grade : $grade",
                fontSize = 15.sp,
                fontWeight = FontWeight.SemiBold,
                color = gradeColor
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = formatStudentSummary(student),
                fontSize = 12.sp,
                color = Color.Gray
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun StudentReportPreview() {
    val students = listOf(
        Student(name = "Jenny",    score = 85.5),
        Student(name = "Rita",     score = null),
        Student(name = "Precious", score = 52.0),
        Student(name = "Glenys",   score = 93.0),
        Student(name = "Paola",    score = 70.0)
    )
    StudentGradeCalculatorKotlinVersionTheme {
        StudentReportScreen(
            students        = students,
            passedStudents  = students.filter { (it.score ?: 0.0) >= 50.0 },
            gradeSummaries  = students.map { "${it.name} → ${calculateGrade(it.score)}" },
            validStudents   = students.filter { isValidScore(it) },
            atRiskStudents  = students.filter { (it.score ?: 0.0) < 60.0 },
            honourRoll      = students.filter { calculateGrade(it.score) == "A" }
        )
    }
}