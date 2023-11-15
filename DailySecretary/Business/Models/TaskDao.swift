//
//  TaskModel.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/30.
//

import CoreData

enum TaskStatus : Int16 {
    case PENDING = 0
    case COMPLETED
    case CANCELED
}

class TaskInfo {
    var taskId : Int64 = 0
    var title : String = ""
    var desc: String = ""
    var status: Int16 = TaskStatus.PENDING.rawValue
    var remindTime: Date?
    var createTime: Date?
    var updateTime: Date?
}

class TaskDao {
    static let instance = TaskDao()
    
    // 持久容器
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model") // 数据模型名称
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("无法加载持久存储：\(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // 上下文
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
}

func saveTask(task: TaskInfo) {
    let context = TaskDao.instance.context
    
    if let taskEntity = NSEntityDescription.entity(forEntityName: "TaskModel", in: context) {
        let newTask = TaskModel(entity: taskEntity, insertInto: context)
        
        newTask.taskId = task.taskId
        newTask.title = task.title
        newTask.desc = task.desc
        newTask.status = task.status
        newTask.remindTime = task.remindTime
        newTask.createTime = task.createTime
        newTask.updateTime = task.updateTime
        
        do {
            try context.save()
            print("数据插入成功")
        } catch {
            print("无法保存人的数据：\(error)")
        }
    }
}

// 返回数据根据 remindTime 升序排列
func fetchTasksOrderByStatus(status : Int16) -> [TaskModel] {
    let context = TaskDao.instance.context
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskModel.fetchRequest()
    let tasksFetchRequest = fetchRequest as! NSFetchRequest<TaskModel>
    
    let predicate = NSPredicate(format: "(status == %d) ", status)
    
    fetchRequest.predicate = predicate
    
    // 设置排序描述符，按时间升序排列
    let sortDescriptor = NSSortDescriptor(key: "remindTime", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    do {
        let results = try context.fetch(tasksFetchRequest)
        return results
    } catch {
        print("无法查询数据：\(error)")
        return []
    }
}

// 返回数据根据 remindTime 升序排列
func fetchTasksOrderByTimeAndStatus(date: Date, status : Int16) -> [TaskModel] {
    let context = TaskDao.instance.context
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskModel.fetchRequest()
    let tasksFetchRequest = fetchRequest as! NSFetchRequest<TaskModel>
    
    // 设置查询条件为与给定日期匹配的记录
    let calendar = Calendar.current
    let startDate = calendar.startOfDay(for: date)
    let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
    
    
    //    let predicate = NSPredicate(format: "(remindTime >= %@) AND (remindTime < %@) AND (status == %d)",
    //                                startDate as NSDate, endDate as NSDate, status)
    let predicate = NSPredicate(format: "(remindTime >= %@) AND (remindTime < %@) AND (status == %d) ", startDate as NSDate, endDate! as NSDate, status)
    
    fetchRequest.predicate = predicate
    
    // 设置排序描述符，按时间升序排列
    let sortDescriptor = NSSortDescriptor(key: "remindTime", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    do {
        let results = try context.fetch(tasksFetchRequest)
        return results
    } catch {
        print("无法查询数据：\(error)")
        return []
    }
}

// 返回数据根据 remindTime 升序排列
func fetchTasksOrderByTime(date: Date) -> [TaskModel] {
    let context = TaskDao.instance.context
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskModel.fetchRequest()
    let tasksFetchRequest = fetchRequest as! NSFetchRequest<TaskModel>
    
    // 设置查询条件为与给定日期匹配的记录
    let calendar = Calendar.current
    let startDate = calendar.startOfDay(for: date)
    let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
    
    let predicate = NSPredicate(format: "(remindTime >= %@) AND (remindTime < %@)", startDate as NSDate, endDate! as NSDate)
    fetchRequest.predicate = predicate
    
    // 设置排序描述符，按时间升序排列
    let sortDescriptor = NSSortDescriptor(key: "remindTime", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    do {
        let results = try context.fetch(tasksFetchRequest)
        return results
    } catch {
        print("无法查询数据：\(error)")
        return []
    }
}

func fetchTaskById(id : String)-> TaskModel? {
    let context = TaskDao.instance.context
    
    // 创建任务对象的查询请求
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskModel.fetchRequest()
    let tasksFetchRequest = fetchRequest as! NSFetchRequest<TaskModel>
    
    let intId = Int64(id)
    if nil == intId {
        return nil
    }
    
    tasksFetchRequest.predicate = NSPredicate(format: "taskId == %ld", intId!)
    
    do {
        let tasks = try context.fetch(tasksFetchRequest)
        
        // 如果找到了匹配的任务对象
        if let task = tasks.first {
            // Map the CoreData entity to your TaskModel
            return task
        }
    } catch {
        print("Error fetching task: \(error)")
    }
    
    return nil
}

func updateTask(task: TaskModel) {
    let context = TaskDao.instance.context
    
    // 创建任务对象的查询请求
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskModel.fetchRequest()
    let tasksFetchRequest = fetchRequest as! NSFetchRequest<TaskModel>
    
    tasksFetchRequest.predicate = NSPredicate(format: "taskId == %ld", task.taskId)
    
    do {
        let tasks = try context.fetch(tasksFetchRequest)
        
        // 如果找到了匹配的任务对象
        if let newTask = tasks.first {
            // 对任务对象进行修改
            newTask.taskId = task.taskId
            newTask.title = task.title
            newTask.desc = task.desc
            newTask.status = task.status
            newTask.remindTime = task.remindTime
            newTask.createTime = task.createTime
            newTask.updateTime = task.updateTime
            
            // 保存上下文
            try context.save()
        }
    } catch {
        print("无法更新数据：\(error)")
    }
}

