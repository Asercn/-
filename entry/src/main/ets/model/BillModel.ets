import relationalStore from '@ohos.data.relationalStore';
import { ColumnInfo, ColumnType } from '../common/bean/ColumnInfo'
import DbUtil from '../common/utils/DbUtil';
import Bill from '../viewmodel/Bill';

/**
 * 建表语句
 */
const CREATE_TABLE_SQL: string =
  `CREATE TABLE IF NOT EXISTS bill(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          label TEXT NOT NULL,
          amount DOUBLE NOT NULL,
          date INTEGER NOT NULL,
          is_expend BOOLEAN NOT NULL,
          group_id INTEGER NOT NULL
        )`
const TABLE_NAME = 'bill'
/**
 * 映射关系表
 */
const COLUMNS: ColumnInfo[] = [
  { name: 'id', columnName: 'id', type: ColumnType.LONG },
  { name: 'label', columnName: 'label', type: ColumnType.STRING },
  { name: 'amount', columnName: 'amount', type: ColumnType.DOUBLE },
  { name: 'date', columnName: 'date', type: ColumnType.LONG },
  { name: 'isExpend', columnName: 'is_expends', type: ColumnType.STRING },
]

class BillModel{
  // 创建表
  getCreateTableSql():string{
    return CREATE_TABLE_SQL;
  }
  /**
   * 向数据库中账单表中插入数据
   * @param bill
   * @returns
   */
  insert(bill:Bill):Promise<number>{
    console.log('testTag','RecordModel','insert()',JSON.stringify(bill));
    return DbUtil.insert(TABLE_NAME,bill,COLUMNS)
  }

  /**
   * 删除账单表中的此id数据
   * @param id
   * @returns
   */
  deleteById(id:number):Promise<number>{
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('id',id)
    return DbUtil.delete(predicates)
  }

  update(bill:Bill):Promise<number>{
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    // 根据id更新
    predicates.equalTo('id',bill.id)
    return DbUtil.update(predicates,bill,COLUMNS)
  }

  /**
   * 根据日期获取账单数据
   * @param date
   * @returns
   */
  listByDate(date:number):Promise<Bill[]>{
    //1.查询条件
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo('date',date)
    return DbUtil.queryForList(predicates,COLUMNS);

  }

  /**
   * 查询范围内日期
   * @param minDate 开始日期
   * @param maxDate 结束日期
   * @returns
   */
  listByDateBetween(minDate:number,maxDate:number):Promise<Bill[]>{
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.between('date',minDate,maxDate)
    return DbUtil.queryForList(predicates,COLUMNS)
  }
}

let billModel = new BillModel()
export default billModel as BillModel